# encoding: utf-8
#
# = main.rb
#
# Main file for running Untappd cataloguer
#
# Author: James Finlay
##

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
dbm = DatabaseManager.new("beer_catalog.db", true)

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

dbm.dumpFuzzyStringDistance("dump.out", 0.7)

puts "Complete"