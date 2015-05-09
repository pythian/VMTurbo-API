
require "httparty"

class VMTConn
	
	include HTTParty
	format :xml
	#Init 
	attr_accessor :vmt_userid, 
				  :vmt_password, 
				  :vmt_url,
				  :ValidUrl,
				  :GetConnection
	
	def initialize(vmt_userid, vmt_password, vmt_url)
		
		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url      = vmt_url
	end

	def ValidUrl?(vmt_url)
		uri = URI.parse(vmt_url)
		uri.kind_of?(URI::HTTP)
	rescue URI::InvalidURIError
		false
	
	end

	def GetConnection(url_endpoint)
		vmt_auth = {:username => "#{@vmt_userid}", :password => "#{@vmt_password}"}
		vmt_uri  = "#{@vmt_url}#{url_endpoint}"
		vmt_response = HTTParty.get("#{vmt_uri}", :basic_auth => vmt_auth)
		
		return vmt_response

	end

end


