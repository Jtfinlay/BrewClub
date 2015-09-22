# encoding: utf-8
#
# = filter_totalwine.rb
#
# Database filter for quering relevant beer types. This will be dependent on the website
# and the user preferences. 
#
# Author: James Finlay
##

require 'sqlite3'
require_relative 'beer'

class FilterTotalWine

    #
    # Object constructor. Sets up the filter query
    #
    def initialize
        # qty filters - get rid of all packs and kegs
        # there might be some 9Ls left but.. yolo
        @filter = "quantity not like '%Btls%'"
        @filter += " and quantity not like '%Cans%'"
        @filter += " and quantity not like '%Keg%'"
        @filter += " and quantity not like '%pk%'"
        @filter += " and quantity not like '%gift pack%'"
        # I don't want to spend over $20 on a single beer
        @filter += " and price < 20.00"
        # Ciders aren't beer
        @filter += " and style not like '%cider%'"
        # @jviau doesn't like stouts
        @filter += " and style not like '%stout%'"
    end

    #
    # Object constructor
    #
    # db: SQLite database containing web catalogue
    # tableName: Beer data table
    #
    def filterWebData(db, tableName)
        result = []
        db.execute("SELECT * FROM #{tableName} WHERE #{@filter}").each do |e|
            result.append BeerModel.new(e[0], e[1], e[2], e[3], 
                e[4], e[5])
        end
        return result
    end


end