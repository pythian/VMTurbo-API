# Require VMTurbo APIs
require_relative '../lib/VMTConn'
require_relative '../lib/market'
require_relative '../lib/reservations'
require_relative '../lib/templates'
require_relative '../lib/groups'

#VMTurbo Connection Variables

VMT_USERID = "administrator"
VMT_PASSWORD = "Sysdreamworks123!"
VMT_BASE_URL = "http://10.32.141.13"

# Shared Support Files Dependancies

Dir["./spec/support/**/*.rb"].each {|f| require f}

require "nokogiri"
require "rspec-xml"
# Build System Requirements
#dependencies
#require 'minitest/autorun'
#require 'webmock/minitest'
#require 'vcr'
#require 'yaml'
#require 'webmock/rspec' 
 


