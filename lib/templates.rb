require 'VMTConn'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'yaml'
require 'cgi'
require 'market'

class Template 

attr_accessor :vmt_userid,
				  :vmt_password,
				  :vmt_url

	def initialize(vmt_userid, vmt_password, vmt_url)

		#Instance Vars
		@vmt_userid   = vmt_userid
		@vmt_password = vmt_password
		@vmt_url	  = vmt_url
	end

	def get_template(template_ID)

		##
		# Gets a template details
		#
		# Optional Methods
		# template_ID => UUID of the template    :: Default list all templates
		##

		if template_ID.nil?
			get_template = VMTConn::query_builder("/vmturbo/api/templates")
		else
			get_template = VMTConn::query_builder("/vmturbo/api/templates/#{template_ID}")
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
end