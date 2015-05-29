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

	def get_markets
		markets = "/vmturbo/api/markets"
		data_hash = VMTConn::get_data(markets)
		return data_hash
	end

	def get_cluster_projections(market_name, options = {})
		
		##
		# Will get cluster projections
		# Method Arguments
		# 
		# Required
		# market_name => Name of market you want to get entities from
		#
		# Optional - Both must be set if you use these optional parameters
		# :entity_type => choose to limit the comparison to a single cluster, the type of entity to query. Can be one of:
		#				- groups
		#				- virtualmachines
		#				- hosts
		#				- datastores 
		# :cluster_ID => UUID of the selected cluster
		## 

		#Set default api endpoint
		
		api_endpoint = "/vmturbo/api/markets/#{market_name}/projections"

		#Check to see if both options are set
	
		if !options[:entity_type].nil? || !options[:cluster_ID].nil?
	
			if !options[:entity_type].nil? && !options[:cluster_ID].nil?
			
				entity_type = options[:entity_type]  	
				cluster_ID  = options[:cluster_ID]	
				api_endpoint = "/vmturbo/api/markets/#{market_name}/#{entity_type}/#{cluster_ID}/projections"
			else
				raise ArgumentError, "Entity type and cluster ID must be set."
			end
		end

		data_hash = VMTConn::get_data(api_endpoint)
		return data_hash
	end

	def get_cluster_capacity(market_name)
		api_endpoint = "/vmturbo/api/markets/#{market_name}/capacity"

		data_hash = VMTConn::get_data(api_endpoint)
		return data_hash
	end

	def compare_market(market_name, comparison_type)
		##
		# Gets data that compares the current state of market entities to the state they would have 
		# if the market accepted all the current recommended actions. Gets data for all entities 
		# of the given type.
		##

		raise ArgumentError, "market_name and comparison_type must be set." if market_name.nil? || comparison_type.nil?

		api_endpoint = "/vmturbo/api/markets/#{market_name}/#{comparison_type}"
		data_hash = VMTConn::get_data(api_endpoint)
		return data_hash

	end

	def compare_group(market_name, group_ID, comparison_type)
		raise ArgumentError, "market_name group_ID or comparison_type are not set" if market_name.nil? || group_ID.nil? || comparison_type.nil?

		api_endpoint = "/vmturbo/api/markets/#{market_name}/group/#{group_ID}/#{comparison_type}"
		data_hash = VMTConn::get_data(api_endpoint)
		return data_hash
	end

	def get_optimal_zone(market_name)
		raise ArgumentError, "market_name is not set" if market_name.nil?

		api_endpoint ="/vmturbo/api/markets/#{market_name}/target"
		data_hash = VMTConn::get_data(api_endpoint)
		return data_hash
		

	end
end
