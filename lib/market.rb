require "VMTConn"
require "nokogiri"

class Market

	attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url

	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	   = vmt_url
	end

	def GetListOfMarkets
		get_markets = "/vmturbo/api/markets"
		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(get_markets)
		market_data = Nokogiri::XML(response.body)
		return market_data
	end

end