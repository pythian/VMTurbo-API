require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'

class Market

	attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url

#Initalize Market Object
	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	   = vmt_url

		#Load entity type from entity_type.yaml
		@entity_list_config = YAML.load_file('config/entity_type.yml')
		@classname_list_config = YAML.load_file('config/classname_type.yml')
	end

#Check that entity type matches a list of entitys
	def entity_type_check(entity_type)
		return case 
			when @entity_list_config.include?(entity_type)    #Validate against the entity_type.yml
				true
			when @classname_list_config.include?(entity_type) #Validate against the classname_type.yml
				true
			else
				false
		end
	end

#Build query parameters for API call
	def query_builder(api_endpoint, entity_options = {})
		if entity_options.is_a?(Hash) 
			query = entity_options.map {|k, v| "#{k}=#{v}" }.join("&")
			query = api_endpoint + "?" + query
		else
			query = api_endpoint
		end 
		return query
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
			raise ArgumentError, "Market Not Found"
		else
			single_market_hash = market_data['TopologyElements']['TopologyElement']
			return single_market_hash
		end	
	end
	  
	def get_entity_list(market_name, entity_query = {})

		##
		# Will get a list of entities and return basic information like UUID
		# Method Arguments
		# 
		# Required
		# market_name => Name of market you want to get entities from
		#
		# Optional
		# :classname => Entity Type                         :: This is checked against a list of valid entities
		# 													   located in the classname_type.yml config file
		# :entity    => Internal Name                       :: internal VMTurbo name
		# :property  => priceIndex, Produces, ProducesSize  :: 
		# :services  => individual service or list all      :: The resources the entity is selling
		# :resource  => get a selection of resources or all :: The resources the entity is buying
		## 
		
		#Validate that the entity is a part of the classname_config.yml
		raise ArgumentError, "Bad Entity Type" if entity_query[:classname].nil? == false && entity_type_check(entity_query[:classname]) == false
		
		# Set API endpoint call based on options
		api_endpoint = query_builder("#{market_name}/entities", entity_query)
		entity_data = get_list(api_endpoint) 
		
		return entity_data

	end

	def get_entity_by_type(market_name, entity_type, entity_query = {})
		
		##
		# Will get a list of entities types and return detailed market data
		# Method Arguments
		# 
		# Required
		# market_name => Name of market you want to get entities from
		# entity_type => Valid entity type                  :: must match from entity_type.yml
		#
		# Optional
		# :classname => Entity Type                         :: This is checked against a list of valid entities
		# 													   located in the classname_type.yml config file
		# :entity    => Internal Name                       :: internal VMTurbo name
		# :property  => priceIndex, Produces, ProducesSize  :: 
		# :services  => individual service or list all      :: The resources the entity is selling
		# :resource  => get a selection of resources or all :: The resources the entity is buying
		##

		#Validate that the entity is a part of the entity_config.yml
		raise ArgumentError, "No Entity Type Passed"  if entity_type.nil?
		raise ArgumentError, "Bad Entity Type Passed" if !entity_type_check(entity_type)
		
		#Build api endpoint call to be passed
		api_endpoint = query_builder("#{market_name}/#{entity_type}", entity_query)

		#Make the call to VMTurbo
		entity_data = get_list(api_endpoint)
		return entity_data
	end

	def get_entity_by_name(market_name, entity_type, entity_name, entity_query = {})


	end

	



















end