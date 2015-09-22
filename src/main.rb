# encoding: utf-8
#
# = main.rb
#
# Main file for running Untappd cataloguer
#
# Author: James Finlay
##

require_relative 'api_keys'
require_relative 'distinct_beers'
require_relative 'crawl_totalwine'
require_relative 'filter_totalwine'

if CLIENT_ID.empty? or CLIENT_SECRET.empty?
    puts "The Untappd client ID and secret must be set. Please do so in api_keys.rb"
    exit
end

##### Web Crawler #####

puts "Pulling store catalogue"

crawler = CrawlTotalWine.new("totalWine")
crawler.crawlAllPages

puts "#{crawler.db.execute('SELECT count(*) FROM totalWine')[0][0]} beer types found"

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
f = FilterTotalWine.new.filterWebData(crawler.db, "totalWine")

puts "Remaining #{f.length}/#{crawler.db.execute('SELECT count(*) FROM totalWine')[0][0]} beers after preliminary filter"

##### Match store with Untappd #####


puts "Complete"