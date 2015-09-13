# encoding: utf-8
#
# = crawl_totalwine.rb
#
# Wombat crawler to collect data from TotalWine.com
#
# Author: James Finlay
##

require 'wombat'

class CrawlTotalWine 
    include Wombat::Crawler

    BASE_PATH = "/beer/c/c0010?viewall=true&nonalcoholic=false&storename=1401&pagesize=200&page="

    base_url "http://www.totalwine.com/"
    path BASE_PATH

    beers"css=.plp-list>li", :iterator do
        name({      css: ".plp-product-title" })
        price({     css: ".price" })
        quantity({  css: ".plp-product-qty"})
        url({       xpath: ".//a[1]/@href" })
        location({  css: ".analyticsCountryState" })
        style({     css: ".analyticsRegion" })
    end
    more({ css: ".pager-next" })

    #
    # Iterate the site catalogue and strip useful metadata.
    #
    def crawlAllPages
        page = 1
        result = []
        loop do
            puts "Page #{page}"
            path BASE_PATH + page.to_s

            response = crawl
            result.concat response["beers"]

            break if response["more"].nil?
            page += 1
        end

        return result
    end

end