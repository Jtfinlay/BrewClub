# encoding: utf-8
#
# = test_database_manager.rb
#
# Unit Tests for the database manager (database_manager.rb)
#
# Author: James Finlay
##

require 'test/unit'
require 'json'
require 'sqlite3'
require_relative 'helper'
require_relative '../src/database_manager.rb'

class TestDatabaseManager < Test::Unit::TestCase

    DB_NAME = "test_database.db"

    #
    # Run before every test
    #
    def setup
        File.delete(DB_NAME) if File.exist?(DB_NAME)
    end

    #
    # Run after every test
    #
    def teardown
        File.delete(DB_NAME) if File.exist?(DB_NAME)
    end

    def test_initialize
        dbm = DatabaseManager.new(DB_NAME)
        assert_nothing_raised do
            dbm.db.execute "SELECT * FROM #{dbm.crawlerTable}"
            dbm.db.execute "SELECT * FROM #{dbm.untappdTable}"
        end

    end

    def test_insertCrawlerBlob
        data = Helper.loadMockData("test/mocks/TotalWine.json")["beers"]
        assert_not_nil data

        dbm = DatabaseManager.new(DB_NAME)
        dbm.insertCrawlerBlob(data)

        assert_equal 20, dbm.getCrawlerCount
    end

    def test_insertUntappdBlob
        data = Helper.loadMockData("test/mocks/DistinctBeerList.json")["response"]
        assert_not_nil data
        assert data["beers"]["count"] > 0

        dbm = DatabaseManager.new(DB_NAME)
        dbm.insertUntappdBlob(data)

        assert_equal data["beers"]["count"], dbm.getUntappdCount
    end


    def test_populateFromJsonList
        data = Helper.loadMockData("test/mocks/DistinctBeerList.json")
        response = data["response"]

        assert_not_nil response

    end

    def test_populateFromCrawler

        
    end

end
