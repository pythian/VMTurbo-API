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

	def get_list(market_name)

		##
		# Gets a list of entities from a market
		#
		# Optional Methods
		# market_name => name of market  :: Default list all markets
		#
		##

		if market_name.nil?
			get_markets = "/vmturbo/api/markets"
		else
			get_markets = "/vmturbo/api/markets/#{market_name}"
		end

		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(get_markets)
		data = Nokogiri::XML(response.body)
		begin
			data_hash = Hash.from_xml(data.to_s)
		rescue
			data_hash = "No Valid XML Found"
		end
		
		return data_hash
	end

	def get_single_market_data(market_name)

		##
		# Will get a single market and return it as a single hash
		#
		# Required parameters
		# market_name => Must be a valid market
		#
		##
		
		market_data = get_list(market_name)
		if market_data == "No Valid XML Found"
			raise ArgumentError, "Bad Market Type"
		else
			single_market_hash = market_data['TopologyElements']['TopologyElement']
			return single_market_hash
		end	
	end
	  
	def get_entity_list(market_name, entity_query = {})

		##
		# Will get a list of entitiy based on type
		# Method Arguments
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
		
		if entity_query[:classname] == nil
			api_endpoint = "#{market_name}/entities"
		else
			api_endpoint = "#{market_name}/entities?classname=#{entity_query[:classname]}"
		end

		api_endpoint = api_endpoint.to_s + "&#{entity_query[:entity]}"     if entity_query[:entity] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:property]}"   if entity_query[:property] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:services]}"   if entity_query[:services] == !nil
		api_endpoint = api_endpoint.to_s + "&#{entity_query[:resource]}"   if entity_query[:resource] == !nil

		entity_data = get_list(api_endpoint) 

		if entity_data['ServiceEntities'] == nil
			 raise ArgumentError, "Bad Entity Type"
		end
		return entity_data

	end

	def get_entity_by_type(market_name, entity_query = {})
	end

end