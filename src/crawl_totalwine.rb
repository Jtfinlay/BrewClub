# encoding: utf-8
#
# = crawl_totalwine.rb
#
# Wombat crawler to collect data from TotalWine.com. This will need to be 
# customized for whichever website you are pulling from.
#
# Author: James Finlay
##

require 'wombat'
require 'sqlite3'
require 'json'

class CrawlTotalWine 
    include Wombat::Crawler
    attr_reader :db

    BASE_PATH = "/beer/c/c0010?viewall=true&nonalcoholic=false&storename=1401&pagesize=200&page="

    base_url "http://www.totalwine.com/"
    path BASE_PATH

    beers "css=.plp-list>li", :iterator do
        name({      css: ".plp-product-title" })
        price({     css: ".price" })
        quantity({  css: ".plp-product-qty"})
        url({       xpath: ".//a[1]/@href" })
        location({  css: ".analyticsCountryState" })
        style({     css: ".analyticsRegion" }, :list)
    end
    more({ css: ".pager-next" })

    #
    # Constructor for the object. Initializes db and crawler
    #
    # tableName: name to use for sqllite table
    #
    def initialize(tableName)
        super()
        @tableName = tableName
        @db = SQLite3::Database.new "online_catalogue.db"
        createTotalWineTable
    end

    #
    # Reset the Total Wine db table
    #
    def createTotalWineTable
        @db.execute "DROP TABLE IF EXISTS #{@tableName};"
        @db.execute <<-SQL
            CREATE TABLE "#{@tableName}" (
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
    # Add crawl responses to the db table
    #
    # response: series of beer metadata from web crawl
    #
    def insertResponse(response)
        response.each do |beer|
            beer['price'] = beer['price'].gsub(/[^\d\.]/, '').to_f
            beer['style'] = JSON.generate(beer['style'])
            @db.execute "INSERT INTO #{@tableName} VALUES (?,?,?,?,?,?)", beer.values
        end
    end

    #
    # Iterate the site catalogue and strip useful metadata.
    #
    def crawlAllPages
        page = 1
        loop do
            puts "Path: #{BASE_PATH}#{page.to_s}"
            path BASE_PATH + page.to_s

            response = crawl
            insertResponse response["beers"]

            break if response["more"].nil?
            page += 1
        end
    end

end