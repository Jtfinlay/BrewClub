# encoding: utf-8
#
# = distinct_beers.rb
#
# Class for managing distinct beer queries
#
# Author: James Finlay
##

#
# The +DistinctBeers+ object acts as a helper class for pulling and managing 
# user information from the Untappd service.
#

require './untappd_helper'
require './beer'

class DistinctBeers
    include UntappdHelper

    BEER_SEARCH_METHOD = "user/beers/"

    #
    # This method will return a limited list of the user's distinct beers.
    #
    # username: User to query
    # offset: The numeric offset that you want results to start at
    # limit: The number of results to return (max of 50)
    #
    def pullDistinctBeers(username, offset, limit=50)
        params = [ "offset=" + offset.to_s,
                    "limit=" + limit.to_s ]
        return GET(username, BEER_SEARCH_METHOD, params)["response"]
    end

    #
    # This method will return a complete list of the user's distinct beers. 
    #
    # username: User to query
    #
    def pullAllDistinctBeers(username)

        results = []
        offset = 0
        loop do
            response = pullDistinctBeers(username, offset)
            offset += response["beers"]["count"]

            break if response["beers"]["count"] == 0
            results.concat BeerModel.populateFromJsonList(response)
        end

        return results
    end

end