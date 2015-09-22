# encoding: utf-8
#
# = error_untappd.rb
#
# Exception object for Untappd query failures
#
# Author: James Finlay
##

#
# The +UntappdError+ object holds relevant data to handle
# problems accessing the Untappd API
#
class UntappdError < StandardError
    attr_reader :object, :url

    def initialize(url, object)
        @url = url
        @object = object
    end
end