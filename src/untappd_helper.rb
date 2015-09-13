# encoding: utf-8
#
# = untappd_helper.rb
#
# Class for managing API calls
#
# Author: James Finlay
##

require 'net/http'
require 'rubygems'
require 'json'
require './api_keys'

#
# The +UntappdHelper+ object manages API calls and responses with the Untappd
# service.
#
module UntappdHelper
    
    UNTAPPD_URL = "https://api.untappd.com/v4/"
    CLIENT_EXT = "client_id="+CLIENT_ID+"&client_secret="+CLIENT_SECRET

    #
    # Perform GET to query unauthenticated method from Untappd
    #
    # user_name: User to query
    # method_name: The type of query to send
    # params: List of parameters pertaining to the method name
    #
    def GET(user_name, method_name, params)

        url = UNTAPPD_URL
        url += method_name + user_name + "?" + CLIENT_EXT

        params.each do |param|
            url += "&" + param
        end

        content = Net::HTTP.get(URI(url))
        response = JSON.parse(content)

        VerifyReturnCode(response)

        return response
    end

    #
    # Verify the Untappd GET response was successful
    #
    # response: Full GET response from Untappd, including meta block
    #
    def VerifyReturnCode(response)
        if response["meta"]["code"] != 200
            # todo: jtfinlay: Don't use general exception
            raise Exception.new(response), "Error code received from Untappd"
        end
    end


end