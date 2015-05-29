require 'spec_helper'

describe Market do
	subject(:market) {Market.new(vmt_userid, vmt_password, vmt_url)}
 	
 	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }
	let(:market_name)	{'Market'}
	
	
	describe "Shoule be a valid VMT API object" do
		it_behaves_like "a VMT API object"
	end

	describe "#get_markets" do
		context "Return a list of markets" do
			let(:data_result)		{market.get_markets}
			it_behaves_like 'return entity'
		end
	end

	describe "#get_cluster_projections" do
		let(:market)		{'Market'}

		context "will return cluster projections" do
			context "for all clusters" do
				let(:data_result)	{market.get_cluster_projections(market_name)}
				it_behaves_like 'return entity'
			end

			context "for one entity type with cluster" do
				let(:cluster_ID)	{''}
				let(:entity_type)	{'hosts'}
				let(:data_result)	{market.get_cluster_projections(market_name, {entity_type: entity_type, cluster_ID: cluster_ID})}
				it_behaves_like 'return entity'
			end
		end
		context "it will throw an exception" do
			let(:data_result)	{market.get_cluster_projections(market_name, {entity_type: entity_type, cluster_ID: cluster_ID})}

			context "if group_ID is set and entity_type is not" do
				let(:cluster_ID)	{ nil }
				let(:entity_type)	{'hosts'}
				it_behaves_like 'Errors'
			
			end

			context "if entity_type is set and group_ID is not" do
				let(:cluster_ID)	{''}
				let(:entity_type)	{ nil }
				it_behaves_like 'Errors'
			
			end
		end
	end

	describe "#get_cluster_capacity" do
		context "will return cluster capacity" do
			let(:data_result)	{market.get_cluster_capacity(market_name)}
				it_behaves_like 'return entity'
		end
	end

	describe "#compare_market" do
		context "will return comparison data for a market" do
			let(:data_result)	{market.compare_market(market_name, comparison_type)}
			context "with host comparison" do
				let(:comparison_type)	{'hostcomparison'}
				it_behaves_like 'return entity'
			end
			context "with storage comparison" do
				let(:comparison_type)	{'storagecomparison'}
				it_behaves_like 'return entity'
			end
		end
		context "will throw an exception if comparison_type is not passed" do
			let(:comparison_type)	{ nil }
			it_behaves_like 'Errors'
		end
	end

	describe "#compare_group" do
		let(:data_result)	{market.compare_group(market_name, group_ID, comparison_type)}
		let(:group_ID)		{''}
		context "will return comparison data for a group" do
			context "with a host comparison" do
				let(:comparison_type) 	{'hostcomparison'}
			end
			context "with a storage comparison" do
				let(:comparison_type)	{'storagecomparison'}
			end
		end
		context "will throw an exception" do
			context "if group ID is not present" do
				let(:group_ID)	{ nil }
				it_behaves_like 'Errors'
			end
			context "if comparison_type is not present" do
				let(:comparison_type)	{ nil }
				it_behaves_like 'Errors'
			end
		end
	end

	describe "#get_optimal_zone" do
		context "will get the data for the Optimal Operation Zone" do
			let(:data_result)	{market.get_optimal_zone(market_name)}
			it_behaves_like 'return entity'

		end
	end
end