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
        @filter = "quantity like '%Btls%'"
        @filter += " or quantity like '%Cans%'"
        @filter += " or quantity like '%Keg%'"
        @filter += " or quantity like '%pk%'"
        @filter += " or quantity like '%gift pack%'"
        # I don't want to spend over $20 on a single beer
        @filter += " or price > 20.00"
        # Ciders aren't beer
        @filter += " or style like '%cider%'"
        # @jviau doesn't like stouts
        @filter += " or style like '%stout%'"
    end

    #
    # Deletes all data matching filter. 
    #
    # Remark: Would be smart to just trip a db field in the future for debugging purposes.
    #
    # db: SQLite database containing web catalogue
    # tableName: Beer data table
    #
    def filterWebData(db, tableName)
        db.execute("DELETE FROM #{tableName} WHERE #{@filter}")
    end


end