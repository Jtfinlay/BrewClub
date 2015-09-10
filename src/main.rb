# encoding: utf-8
#
# = main.rb
#
# Main file for running Untappd cataloguer
#
# Author: James Finlay
##

require './api_keys'

if CLIENT_ID.empty? or CLIENT_SECRET.empty?
    puts "The Untappd client ID and secret must be set. Please do so in api_keys.rb"
    exit
end

# todo: jtfinlay: ...
