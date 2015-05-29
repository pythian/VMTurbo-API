#Required Modules
require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'

class Market

	attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url,
				  :query_builder

#Initalize Entity Object
	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	   = vmt_url
	end
end