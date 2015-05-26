require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'

class Group 

	attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url

	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	  = vmt_url


	end

	def get_group_list(group_ID)

		if group_ID.nil?
			get_template = "/vmturbo/api/groups"
		else
			get_template = "/vmturbo/api/groups/#{group_ID}"
		end

		conn = VMTConn.new(@vmt_userid, @vmt_password, @vmt_url)
		response = conn.GetConnection(get_template)
		data = Nokogiri::XML(response.body)
		begin
			data_hash = Hash.from_xml(data.to_s)
		rescue
			data_hash = "No Valid XML Found"
		end
		
		return data_hash

	end

	def get_group_members(group_ID)

		raise ArgumentError, "Group ID required" if group_ID.nil? == true

		data_hash = get_group_list("#{group_ID}/entities")
		return data_hash

	end

end