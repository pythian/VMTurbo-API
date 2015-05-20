require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'

class Reservation

	attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url

	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	   = vmt_url
	end

	def query_builder(api_endpoint, reservation_options = {})
		if reservation_options.is_a?(Hash) 
			query = reservation_options.map {|k, v| "#{k}=#{v}" }.join("&")
			query = api_endpoint + "?" + query
		else
			query = api_endpoint
		end 
		return query
	end
	
	def get_reservation(reservation_ID, state = {})

		##
		# Gets a list of entities from a market
		#
		# Optional Methods
		# market_name => name of market  :: Default list all markets
		#
		##

		if reservation_ID.nil?
			get_reservation = query_builder("/vmturbo/api/reservations", state)
		else
			get_reservation = query_builder("/vmturbo/api/reservations/#{reservation_ID}", state)
		end

		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(get_reservation)
		data = Nokogiri::XML(response.body)
		begin
			data_hash = Hash.from_xml(data.to_s)
		rescue
			data_hash = "No Valid XML Found"
		end
		
		return data_hash
	end
end