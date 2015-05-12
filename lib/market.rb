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

	##
	# GetEntityList Method Arguments
	# 
	# Required
	# market_name => Name of market you want to get entities from
	#
	# Optional
	# :classname => Entity Type                         :: Default list all
	# :entity    => Internal Name                       :: Default is nil
	# :property  => priceIndex, Produces, ProducesSize  :: Default is nil
	# :services  => individual service or list all      :: Default is nil
	# :resource  => get a selection of resources or all :: Default is nil
	##   
	def GetEntityList(market_name, entity_query = {})
		
		if entity_query[:classname] == nil
			api_endpoint = "#{market_name}/entities"
		else
			api_endpoint = "#{market_name}/entities?classname=#{entity_query[:classname]}"
		end

		api_endpoint = api_endpoint.to_s + "&#{entity_query[:entity]}"     if entity_query[:entity] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:property]}"   if entity_query[:property] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:services]}"   if entity_query[:services] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:resource]}"   if entity_query[:resource] == !nil

		entity_data = GetListOfMarkets(api_endpoint) 
		entity_data_hash = Hash.from_xml(entity_data.to_s)
		if entity_data_hash['ServiceEntities'] == nil
			 raise ArgumentError, "Bad Entity Type"
		end
		return entity_data_hash

	end

end