require 'spec_helper'

describe Market do
	subject(:market) { Market.new(vmt_userid, vmt_password, vmt_url) }
 	
 	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }
	
	
	describe "Shoule be a valid VMT API object" do
		it_behaves_like "a VMT API object"
	end

	describe "#query_builder" do
		let(:api_endpoint) { 'Market/entities'}
		let(:classname)    { 'Storage' }
		let(:entity)	   { 'datastore-64' }
		let(:property)     { 'priceIndex' }
		let(:services)	   { 'capacity' }
		let(:resource)     { 'Mem_utilization' }
		let(:starttime)	   { '10291467' }
		let(:endtime)	   { '95768342' }

		context "will return a valid query" do
			
			it "returns a valid get_entity_list query without parameters" do
				query = market.query_builder(api_endpoint, nil)
				expect(query).to eql "Market/entities"
			end
			it "returns a valid get_entity_list query with parameters" do
				query = market.query_builder(api_endpoint, {:classname => classname, entity: entity, property: property, service: services, resource: resource})
				expect(query).to eql "Market/entities?classname=#{classname}&entity=#{entity}&property=#{property}&service=#{services}&resource=#{resource}"
			end
		end

	end
	describe "#entity_type_check" do
		context "returns true with a valid type of" do
			let(:result)      { true }
			context "entity" do
				let(:entity_type) {'hosts'}
				it_behaves_like 'a valid result'
			end
			context "classname" do
				let(:entity_type) {'Storage'}
	            it_behaves_like 'a valid result'
			end
		end

		context "returns false with an invalid type of" do
			let(:result)      { false }
			context "entity" do
				let(:entity_type) {'badhost'}
				it_behaves_like 'a valid result'
			end
			context "classname" do
				let(:entity_type) {'badStorage'}
	            it_behaves_like 'a valid result'
			end
		end
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
		
		context "will return a hash of" do

			let(:entity_root) {'ServiceEntities'}
			let(:entity_node) {'ServiceEntity'}
			let(:entity_attr) {'creationClassName'}
			

			context "all market entities" do

				
				let(:valid_data)        { "Application" }
				
				it "valid hash" do
					data_result = market.get_entity_list(market_name)
					expect(data_result[entity_root][entity_node][0][entity_attr]).to eql "#{valid_data}"
				end
			end

			context "single type of entity class" do
	
				let(:classname)    {"Storage"}
				let(:entity_query) {{:classname => classname}}
				let(:valid_data)   { classname }

				it_behaves_like 'return entity'	
			end

			context "single class entity" do
				
				let(:classname)    {'Storage'}
				let(:entity)	   {'datastore-64'}
				let(:entity_query) {{:classname => classname, :entity => entity}}
				let(:entity_attr) {'name'}
				let(:valid_data)  {entity}
				
				context "retuns a single entity valid hash" do
					it_behaves_like 'a single entity'
				end
			end

		
			context "will throw an exception" do
				let(:market_name)  {"Market"}
				let(:classname)    {"badentity"}
				let(:entity_query) {{:classname => classname}}
				it "with bad entity data" do 
					expect{data_result = market.get_entity_list(market_name, entity_query)}.to raise_exception ArgumentError
				end
			end
		end
	end

	describe "#get_entity_by_type" do

		let(:market_name) {"Market"}
		let(:entity_type) {'hosts'}
		let(:entity)	  { nil }
		let(:property)    { nil }
		let(:services)	  { nil }
		let(:resource)    { nil }
		context "will get an entity type" do
			
			let(:entity_root)   {'ServiceEntities'}
			let(:entity_node)   {'ServiceEntity'}
			let(:entity_type)   {'hosts'}
			let(:entity)        {'com.xensource.xenapi.Host@b0e93fc6'}
			let(:entity_attr)   {'displayName'}
			let(:valid_data)    {'XenServer1'}
			let(:entity_query)  {{:entity => entity}}
			
			it "will return a valid hash" do
				data_result = market.get_entity_by_type(market_name, entity_type, entity_query)
				expect(data_result[entity_root][entity_node][entity_attr]).to eql "#{valid_data}"
			end
		end

		context "will throw an exception" do
			context "with the wrong" do
				let(:entity_type) {'badentity'}
				it_behaves_like "entity data"
			end
			context "with no" do
				let(:entity_type) { nil }
				it_behaves_like "entity data"
			end
		end
	end

	describe "#get_entity_by_name" do
		let(:market_name) {"Market"}
		let(:entity_type) {'datastores'}
		let(:entity_root) {'ServiceEntities'}
		let(:entity_node) {'ServiceEntity'}
		let(:entity_attr) {'name'}
		let(:property)    { nil }
		let(:services)	  { nil }
		let(:resource)    { nil }
		let(:starttime)   { nil }
		let(:endtime)     { nil }

		context "get entity data" do
			
			
			let(:entity_name) {'datastore-64'}
			let(:valid_data)  {entity_name}
			it "will get the entity by name" do
				data_result = market.get_entity_by_name(market_name, entity_type, entity_name)
				expect(data_result[entity_root][entity_node][entity_attr]).to eql "#{valid_data}"
			end
		end
		context "get entity data" do

			let(:entity_name) {'4f7c3a15-76877636-7a99-002590024b37'}
			let(:entity_attr) {'uuid'}
			let(:valid_data)  {entity_name}
			it "will get the entity by UUID" do
				data_result = market.get_entity_by_name(market_name, entity_type, entity_name)
				expect(data_result[entity_root][entity_node][entity_attr]).to eql "#{valid_data}"
			end

		end
	end
























end