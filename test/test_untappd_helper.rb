# encoding: utf-8
#
# = test_untappd_helper.rb
#
# Unit Tests for Untappd Helper (untappd_helper.rb)
#
# Author: James Finlay
##

require 'test/unit'
require_relative 'helper'
require_relative '../src/untappd_helper'

class TestUntappdHelper < Test::Unit::TestCase
    include UntappdHelper

    def test_getUserBeerSuccess
        assert_equal 200, GET("jtfinlay", "user/beers/", Array.new)["meta"]["code"]
    end

    def test_getUserBeerFailure
        # 404 Error
        assert_raise UntappdError do
            GET("jtfinlay", "invalid_method", Array.new)
        end

        # API Error
        assert_raise UntappdError do
            GET("", "user/beers/", Array.new)
        end
    end


end