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
require_relative 'crawl_totalwine'
require_relative 'database_manager'
require_relative 'distinct_beers'
require_relative 'filter_totalwine'

if CLIENT_ID.empty? or CLIENT_SECRET.empty?
    puts "The Untappd client ID and secret must be set. Please do so in api_keys.rb"
    exit
end

##### Set up database #####

puts "Setting up database"
dbm = DatabaseHelper.new


##### Web Crawler #####

puts "Pulling store catalogue"

crawler = CrawlTotalWine.new("totalWine")
crawler.crawlAllPages

# todo: jtfinlay: Maybe just make your code better so you don't hit memory problems.
db = crawler.db
crawler = nil
GC.start

puts "#{db.execute('SELECT count(*) FROM totalWine')[0][0]} beer types found"

##### Untappd Logic #####

puts "Pulling Untappd catalogue"

helper = DistinctBeers.new
users = ["jtfinlay", "esdegraff", "jviau"]

beer_collection = []
users.each { |user|
    beers = helper.pullAllDistinctBeers(user)
    puts "#{user} has #{beers.length.to_s} distinct beers"
    beer_collection.concat beers
}
distinct_beers = beer_collection.uniq{|b| b.name}

puts "Users have checked in #{distinct_beers.length.to_s} distinct Untappd beers"

##### Filter store #####
totalCount = db.execute('SELECT count(*) FROM totalWine')[0][0]
filtered = FilterTotalWine.new.filterWebData(db, "totalWine")

puts "Remaining #{db.execute('SELECT count(*) FROM totalWine')[0][0]}/#{totalCount} beers after preliminary filter"

##### Match store with Untappd #####

# todo: jtfinlay: This is a temp dump for checking string distance
# todo: jtfinlay: Yes.. I know this code is just.... horrible.
jarrow = FuzzyStringMatch::JaroWinkler.create( :native )
open('dump.out', 'w') { |file|
    db.execute('SELECT * FROM totalWine').each { |e|
        b = BeerModel.new(e[0], e[1], e[2], e[3], e[4], e[5])
        distinct_beers.each { |untappd|
            distance = jarrow.getDistance( b.name, untappd.name)
            file.puts "#{distance}: #{b.name} ------ #{untappd.name}"
        }
    }
}

puts "Complete"