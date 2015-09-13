# encoding: utf-8
#
# = test_beer.rb
#
# Unit Tests for beer model (beer.rb)
#
# Author: James Finlay
##

gem 'test-unit'

require 'test/unit'
require 'json'
require './test_helper'
require_relative '../beer.rb'

class TestBeer < Test::Unit::TestCase

    def test_initialize
        b = TestHelper.loadMockData("mocks/RinceCochon.json")

        m = BeerModel.new(b["bid"], b["beer_name"], b["beer_label"], b["beer_abv"],
            b["beer_ibu"], b["beer_style"], b["beer_description"],
            b["rating_score"], b["rating_count"])

        assert_equal b["bid"], m.id

    end

    def test_populateFromJsonList
        data = TestHelper.loadMockData("mocks/DistinctBeerList.json")
        response = data["response"]

        assert_not_nil response
        assert response["beers"]["count"] > 0

        result = BeerModel.populateFromJsonList(response)

        assert_equal response["beers"]["count"], result.length
    end

end