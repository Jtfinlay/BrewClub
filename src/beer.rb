# encoding: utf-8
#
# = beer.rb
#
# Class for beer model
#
# Author: James Finlay
##

class BeerModel
    attr_reader :id, :name, :label, :abv, :ibu, :style, :description,
        :rating_score, :rating_count, :price, :quantity, :url, :location


    def initialize *args
        case args.size
        when 6
            init_crawler *args
        when 9
            init_untappd *args
        else
            error
        end
    end

    #
    # Initiailizes a beer model from web crawler data
    #
    def init_crawler name, price, qty, url, location, style
        @name = name
        @price = price
        @quantity = qty
        @url = url
        @location = location
        @style = style
    end

    #
    # Initializes beer models from Untappd variables
    #
    def init_untappd bid, name, label, abv, ibu, style, description, rating_score, rating_count
        @id = bid
        @name = name
        @label = label
        @abv = abv
        @ibu = ibu
        @style = style
        @description = description
        @rating_score = rating_score
        @rating_count = rating_count
    end

    #
    # Initializes beer models from given JSON blob
    #
    # data: JSON blob of the response data
    #
    def self.populateFromJsonList(data)
        return data["beers"]["items"].map { |item|
            b = item["beer"]
            BeerModel.new(b["bid"], b["beer_name"], b["beer_label"], b["beer_abv"],
                b["beer_ibu"], b["beer_style"], b["description"], 
                b["rating_score"], b["rating_count"])
        }
    end
end