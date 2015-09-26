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

require_relative 'database_manager'

class CrawlTotalWine 
    include Wombat::Crawler

    base_url "http://www.totalwine.com/"
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
    def initialize storename, dbm
        super()
        @dbm = dbm
        @basePath = "/beer/c/c0010?viewall=true&nonalcoholic=false&storename=#{storename}&pagesize=200&page="
    end

    #
    # Iterate the site catalogue and strip useful metadata.
    #
    def crawlAllPages
        page = 1
        loop do
            puts "Path: #{@basePath}#{page.to_s}"
            path "#{@basePath}#{page.to_s}"

            response = crawl
            @dbm.insertCrawlerBlob response["beers"]

            break if response["more"].nil?
            page += 1
        end
    end

end