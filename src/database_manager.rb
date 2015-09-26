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
    attr_reader :db, :crawlerTable, :untappdTable

    #
    # Initialize database and tables
    #
    # todo: save old table entries and use versioning
    #
    def initialize(dbName)
        @crawlerTable = "crawlerTable"
        @untappdTable = "untappdTable"

        @db = SQLite3::Database.new dbName
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
            CREATE TABLE "#{@untappdTable}" (
                id float,
                name varchar(40),
                beer_label varchar(40),
                abv float,
                ibu float,
                style varchar(40),
                description varchar(60),
                rating_score float,
                rating_count float
            );
        SQL
    end

    #
    # Insert beer data into the database from a crawler's JSON blob
    #
    def insertCrawlerBlob(data)
        data.each do |beer|
            beer['price'] = beer['price'].gsub(/[^\d\.]/, '').to_f
            beer['style'] = JSON.generate(beer['style'])
            @db.execute "INSERT INTO #{@crawlerTable} VALUES (?,?,?,?,?,?)", beer.values
        end
    end

    #
    # Insert unique beer data into the database from Untappd data
    #
    def insertUntappdBlob(data)
        data["beers"]["items"].map { |item|
            b = item["beer"]
            @db.execute "INSERT INTO #{@untappdTable} VALUES (?,?,?,?,?,?,?,?,?)",
                [b["bid"], b["beer_name"], b["beer_label"], b["beer_abv"],
                b["beer_ibu"], b["beer_style"], b["description"], 
                b["rating_score"], b["rating_count"]]
        }
    end


    #
    # Query count of crawler table
    #
    def getCrawlerCount
        db.execute("SELECT count(*) FROM #{@crawlerTable}")[0][0]
    end

    #
    # Query count of untappd table
    #
    def getUntappdCount
        db.execute("SELECT count(*) FROM #{@untappdTable}")[0][0]
    end

    #
    # Count unique beers in untappd table
    #
    def getUntappdUniqueCount
       db.execute("SELECT count(name) FROM #{@untappdTable}")[0][0]
    end

    #
    # Unique beers in untappd table
    #
    def getUntappdUnique
        db.execute("SELECT name FROM #{@untappdTable} GROUP BY name")
    end

end 