# encoding: utf-8
#
# = test_helper.rb
#
# Static Helper for running Unit Tests
#
# Author: James Finlay
##

class TestHelper

    #
    # Load a mock file as a JSON blob
    #
    # fileName: path to desired mock file
    #
    def self.loadMockData(fileName)
        file = File.open(fileName, "r")
        data = JSON.parse(file.read)
        file.close
        return data
    end

end
