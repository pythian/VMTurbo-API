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

		let(:xpath)       {'//TopologyElement[@displayName="Market"]'}
		let(:valid_data)  {'Market'}
		context "will make a call to VMTurbo" do
			context "will return all markets" do
				
				let(:market_name) {}
				it_behaves_like 'return market'
			end

			context "will return a single market" do
				
				let(:market_name) {'Market'}
				it_behaves_like 'return market'
			end
		end
	end
	
	describe "#GetSingleMarketData" do
		context "will return single market array" do
			
			let(:market_name) {'Market'}
			it "will get the real time market " do			
				results = market.GetSingleMarketData(market_name)
				expect(results["displayName"]).to eq "Market"
			end
		end
		context "will throw an exception" do
			
			let(:market_name) {'badmarketdata'}
			it "if the market does not exist" do
				expect{results = market.GetSingleMarketData(market_name)}.to raise_exception ArgumentError
			end
		end
	end

	describe "#GetEntityList" do

		let(:market_name) {"Market"}
		let(:classname)   { nil }
		let(:entity)	  { nil }
		let(:property)    { nil }
		let(:services)	  { nil }
		let(:resource)    { nil }
		
		context "will return a hash of entities" do

			let(:entity_root) {'ServiceEntities'}
			let(:entity_node) {'ServiceEntity'}
			let(:entity_attr) {'creationClassName'}
			

			context "all market entities" do

				let(:valid_data)  { "Application" }
				it_behaves_like 'return entity'
			end

			context "single type of entity" do
				let(:valid_data)  {"Storage"}
				let(:classname) { valid_data }

				it_behaves_like 'return entity'	
			end
		
			context "will throw an exception" do
				let(:market_name) {"Market"}
				let(:classname) {"badentity"}
				it "with bad entity data" do 
					expect{data_result = market.GetEntityList(market_name, {:classname => classname, :entity => entity, :property => property, :services => services, :resource => resource})}.to raise_exception ArgumentError
				end
			end
		end
	end
end