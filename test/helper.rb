# encoding: utf-8
#
# = helper.rb
#
# Static Helper for running Unit Tests
#
# Author: James Finlay
##

require 'simplecov'
SimpleCov.start
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

class Helper

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

