
require "httparty"
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'
require 'yaml'

class VMTConn
	
	include HTTParty
	format :xml
	#Init 
	attr_accessor :vmt_userid, 
				  :vmt_password, 
				  :vmt_url,
				  :ValidUrl,
				  :GetConnection,
				  :get_data
	
	def initialize(vmt_userid, vmt_password, vmt_url)
		
		#Instance Vars
		vmt_config	  = YAML.load_file('config/config.yml')
		@vmt_userid   = vmt_userid 		||= vmt_config['vmt_userid']
		@vmt_password = vmt_password	||= vmt_config['vmt_password']
		@vmt_url      = vmt_url			||= vmt_config['vmt_hostname']
	end

	def self.query_builder(api_endpoint, entity_options = {})
		if entity_options.is_a?(Hash) 
			query = entity_options.map {|k, v| "#{k}=#{v}" }.join("&")
			query = api_endpoint + "?" + query
		else
			query = api_endpoint
		end 
		return query
	end

	def self.get_data(api_endpoint)
		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(api_endpoint)
		data = Nokogiri::XML(response.body)
		begin
			data_hash = Hash.from_xml(data.to_s)
		rescue
			data_hash = "No Valid XML Found"
		end
		
		return data_hash
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


