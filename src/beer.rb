# encoding: utf-8
#
# = beer.rb
#
# Class for beer model
#
# Author: James Finlay
##

class BeerModel
    attr_reader :id, :name, :label, :abv, :ibu, :style, 
        :description, :rating_score, :rating_count

    #
    # Initializes a beer model from given parameters
    #
    # remark: Don't feel like explaining them all. They map to different beer attributes
    #
    def initialize(id, name, label, abv, ibu, style, description, rating_score, rating_count)
        @id = id
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