require "VMTConn"
require "nokogiri"
require "active_support/core_ext/hash/conversions"

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

	def GetListOfMarkets(market_name)
		if market_name.nil?
			get_markets = "/vmturbo/api/markets"
		else
			get_markets = "/vmturbo/api/markets/#{market_name}"
		end

		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(get_markets)
		market_data = Nokogiri::XML(response.body)
		return market_data
	end

	def GetSingleMarketData(market_name)
		
		market_data = GetListOfMarkets(market_name)
		if market_data.root == nil
			raise ArgumentError, "Bad Market Type"
		else
			market_data_hash = Hash.from_xml(market_data.to_s)
			single_market_hash = market_data_hash["TopologyElements"]["TopologyElement"]
			return single_market_hash
		end
		
	end

	def GetServiceEntity(market_name, entity_type)

		if entity_type.downcase == 'all'
			api_endpoint = "#{market_name}/entities"
		else
			api_endpoint = "#{market_name}/entities?classname=#{entity_type}"
		end

		entity_data = GetListOfMarkets(api_endpoint) 
		entity_data_hash = Hash.from_xml(entity_data.to_s)
		if entity_data_hash['ServiceEntities'] == nil
			 raise ArgumentError, "Bad Entity Type"
		end
		return entity_data_hash

	end

end