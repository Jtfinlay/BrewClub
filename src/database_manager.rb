# encoding: utf-8
#
# = database_manager.rb
#
# Manager class to deal with database & related queries.
#
# Author: James Finlay
##

require 'sqlite3'
require 'json'

class DatabaseManager
    attr_reader :db

    @crawlerTable = "crawlerTable"
    @untappdTable = "untappdTable"

    #
    # Initialize database and tables
    #
    # todo: save old table entries and use versioning
    #
    def initialize
        @db = SQLite3::Database.new "beer_catalog.db"
        resetCrawlerTable
        resetUntappdTable
    end

    #
    # Reset table that stores web crawler beer data
    #
    def resetCrawlerTable
        @db.execute "DROP TABLE IF EXISTS #{@crawlerTable};"
        @db.execute <<-SQL
            CREATE TABLE "#{@crawlerTable}" (
                name varchar(40),
                price float,
                quantity varchar(20),
                url varchar(50),
                location varchar(40),
                style varchar(50)
            );
        SQL
    end

    #
    # Reset table that stores Untappd query beer data
    #
    def resetUntappdTable
        @db.execute "DROP TABLE IF EXISTS #{@untappdTable};"
        @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS "#{@untappdTable}" (
                name varchar(40),
                price float,
                quantity varchar(20),
                url varchar(50),
                location varchar(40),
                style varchar(50)
            );
        SQL
    end

    #
    # Insert a JSON blob of beers from the web crawler into the database
    #
    def insertCrawlerBlob data
        data.each do |beer|
            beer['price'] = beer['price'].gsub(/[^\d\.]/, '').to_f
            beer['style'] = JSON.generate(beer['style'])
            @db.execute "INSERT INTO #{@crawlerTable} VALUES (?,?,?,?,?,?)", beer.values
        end
    end



end 