require 'spec_helper'

describe VMTConn do
	subject(:vmtconn) { VMTConn.new(vmt_userid, vmt_password, vmt_url) }	
	
	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }

	describe "Shoule be a valid VMT API object"do
		it_behaves_like "a VMT API object"
	end
	
	describe "#ValidUrl" do

		context "checks to see if URL is valid" do
			it { expect(vmtconn.ValidUrl?(vmtconn.vmt_url)).to be true}
		end

		context "return false when passed a bad URL" do
			let(:vmt_url) {"thisisabadurl"}
			it { expect(vmtconn.ValidUrl?(vmtconn.vmt_url)).to be false}
		end
	end

	describe "#GetConnection" do
		it_behaves_like "a connection to VMTurbo"	
	end
end