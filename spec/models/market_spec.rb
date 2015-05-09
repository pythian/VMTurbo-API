require 'spec_helper'

describe Market do
	subject(:market) { Market.new(vmt_userid, vmt_password, vmt_url) }
 	
 	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }

	describe "Shoule be a valid VMT API object" do
		it_behaves_like "a VMT API object"
	end

	describe "#GetListOfMarkets" do

		context "will make a call to VMTurbo" do
			it "will return a data set" do
				test = Market.new(vmt_userid, vmt_password, vmt_url)
				market_response = test.GetListOfMarkets
				expect(market_response).to have_xpath("//TopologyElement[@displayName=\"Market\"]")
			end
		end
	end
end