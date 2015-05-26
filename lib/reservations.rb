require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'
require 'entities'

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

	def get_reservation(reservation_ID, state = {})

		##
		# Gets a reservation details
		#
		# Optional Methods
		# reservation_ID => UUID of the reservation  :: Default list all reservations
		# state => 	the state of the reservation 	 :: Call the state of the reservation
		##

		if reservation_ID.nil?
			get_reservation = VMTConn::query_builder("/vmturbo/api/reservations", state)
		else
			get_reservation = VMTConn::query_builder("/vmturbo/api/reservations/#{reservation_ID}", state)
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