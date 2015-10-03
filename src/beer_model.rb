# encoding: utf-8
#
# = beer_model.rb
#
# Beer object to hold relevant beer data. More useful than an array.
#
# Author: James Finlay
##

class BeerModel
    attr_reader :name, :price, :quantity, :url, :location, :style,
        :id, :brewery, :beer_label, :abv, :ibu, :description, :rating_score,
        :rating_count, :display_name

    def initialize(args)
        case args.length
        when 6
            init_crawler(args)
            @display_name = @name
        when 10
            init_untappd(args)
            @display_name = "#{@brewery} #{@name}"
        else
            raise "Initialize BeerModel - Invalid args length: #{args.length}"
        end

        cleanDisplayName
    end

    def init_crawler(args)
        @name, @price, @quantity, @url, @location, @style = args
    end

    def init_untappd(args)
        @id, @name, @brewery, @beer_label, @abv, @ibu, @style, @description,
            @rating_score, @rating_count = args
    end

    #
    # Toy with the beer name to try and improve the matching accuracy
    #
    def cleanDisplayName
        # Brewery suffix
        @display_name.slice! "Brewery & Taproom"
        @display_name.slice! "Brewery"
        @display_name.slice! "Brewing Company"
        @display_name.slice! "Brewing Co."
        @display_name.slice! "Beer Co."
        @display_name.slice! "Family Brewers"
        @display_name.slice! "Breweries"
        @display_name.slice! "Brasserie"
        @display_name.slice! "Brewing"

        # Beer names
        @display_name.sub!("DBA", "Double Barrel Ale")
        @display_name.sub!("IPA", "India Pale Ale")
        @display_name.sub!("Kölsch", "Kolsch")
    end

end