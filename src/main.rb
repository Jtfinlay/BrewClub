# encoding: utf-8
#
# = main.rb
#
# Main file for running Untappd cataloguer
#
# Author: James Finlay
##

require './api_keys'
require './distinct_beers'
require './crawl_totalwine'

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

puts "Total of #{beer_collection.length.to_s} beers"
puts "Total of #{distinct_beers.length.to_s} distinct beers"

puts "Complete"

##### Filter store #####

##### Match store with Untappd #####