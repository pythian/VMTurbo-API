require 'spec_helper'

describe Market do
	subject(:market) { Market.new(vmt_userid, vmt_password, vmt_url) }
 	
 	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }
	
	
	describe "Shoule be a valid VMT API object" do
		it_behaves_like "a VMT API object"
	end

	describe "#get_list" do
		
		let(:entity_root) {'TopologyElements'}
		let(:entity_node) {'TopologyElement'}
		let(:entity_attr) {'creationClassName'}
		let(:valid_data)  {'Market'}

	
		context "will return all markets" do

			let(:market_name) { nil }
			it_behaves_like 'return market'
		end
	end
	
	describe "#get_single_market_data" do

		
		context "will return a single market" do
			
			let(:market_name) {'Market'}
			it "as a single hash" do			
				results = market.get_single_market_data(market_name)
				expect(results['displayName']).to eq "Market"
			end
		end
		context "will throw an exception" do
			
			let(:market_name) {'badmarketdata'}
			it "if the market does not exist" do
				expect{results = market.get_single_market_data(market_name)}.to raise_exception ArgumentError
			end
		end
	end

	describe "#get_entity_list" do

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

			context "single type of entity class" do
				let(:valid_data)  {"Storage"}
				let(:classname) { valid_data }

				it_behaves_like 'return entity'	
			end

			context "single class entity" do
				let(:classname)  {'Storage'}
				let(:entity)     {'datastore-64'}
				let(:valid_data) { classname }

				it_behaves_like 'return entity'
			end

		
			context "will throw an exception" do
				let(:market_name) {"Market"}
				let(:classname) {"badentity"}
				it "with bad entity data" do 
					expect{data_result = market.get_entity_list(market_name, {:classname => classname, :entity => entity, :property => property, :services => services, :resource => resource})}.to raise_exception ArgumentError
				end
			end
		end
	end

	describe "#get_entity_by_type" do

	end
end