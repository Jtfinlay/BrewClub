# encoding: utf-8
#
# = main.rb
#
# Main file for running Untappd cataloguer
#
# Author: James Finlay
##

require 'fuzzystringmatch'

require_relative 'api_keys'
require_relative 'beer_helper'
require_relative 'crawl_totalwine'
require_relative 'database_manager'
require_relative 'filter_totalwine'

if CLIENT_ID.empty? or CLIENT_SECRET.empty?
    puts "The Untappd client ID and secret must be set. Please do so in api_keys.rb"
    exit
end

##### Set up database #####

puts "Setting up database"
dbm = DatabaseManager.new("beer_catalog.db")

##### Web Crawler #####

puts "Pulling store catalogue"
crawler = CrawlTotalWine.new(1401, dbm)
crawler.crawlAllPages

puts "#{dbm.getCrawlerCount} beer entries found"

##### Untappd Logic #####

puts "Pulling Untappd catalogue"

helper = BeerHelper.new
["jtfinlay", "esdegraff", "jviau"].each { |user|
    helper.pullAllDistinctBeers(user, dbm)
}
puts "Users have checked in #{dbm.getUntappdUniqueCount} distinct Untappd beers"

##### Filter store #####

preTotal = dbm.getCrawlerCount
filtered = FilterTotalWine.new.filterWebData(dbm.db, dbm.crawlerTable)

puts "Remaining #{dbm.getCrawlerCount}/#{preTotal} beers after preliminary filter"

##### Match store with Untappd #####

# todo: jtfinlay: This is a temp dump for checking string distance
# todo: jtfinlay: Yes.. I know this code is just.... horrible.
jarrow = FuzzyStringMatch::JaroWinkler.create( :native )
open('dump.out', 'w') { |file|
    dbm.db.execute("SELECT * FROM #{dbm.crawlerTable}").each { |e|
        web = BeerModel.new(e[0], e[1], e[2], e[3], e[4], e[5])
        dbm.getUntappdUnique.each { |uname|
            distance = jarrow.getDistance( b.name, uname)
            file.puts "#{distance}: #{b.name} ------ #{uname}"
        }
    }
}

puts "Complete"