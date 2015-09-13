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

if CLIENT_ID.empty? or CLIENT_SECRET.empty?
    puts "The Untappd client ID and secret must be set. Please do so in api_keys.rb"
    exit
end

helper = DistinctBeers.new
puts helper.pullAllDistinctBeers("jtfinlay")

puts "Complete"

# todo: jtfinlay: ...

