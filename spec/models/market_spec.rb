require 'spec_helper'

describe Entity do
	subject(:market) {Market.new(vmt_userid, vmt_password, vmt_url)}
 	
 	let(:vmt_userid)    { VMT_USERID }
	let(:vmt_password)  { VMT_PASSWORD }
	let(:vmt_url)       { VMT_BASE_URL }
	
	
	describe "Shoule be a valid VMT API object" do
		it_behaves_like "a VMT API object"
	end

	describe "#get_markets" do
		context "Return a list of markets" do
			(:data_result)		{market.get_markets}
			it_behaves_like 'return entity'
		end
	end

	describe "#get_cluster_projections" do
		context "will return cluster projections" do
			context "for all clusters" do
				(:data_result)	{market.get_cluster_projections(market_name)}
				it_behaves_like 'return entity'
			end

			context "for one entity type with cluster" do
				(:cluster_ID)	{''}
				(:entity_type)	{'hosts'}
				(:data_result)	{market.get_cluster_projections(market_name, {entity_type: entity_type, cluster_ID: cluster_ID})}
				it_behaves_like 'return entity'
			end
		end
		context "it will throw an exception" do
			(:data_result)	{market.get_cluster_projections(market_name, {entity_type: entity_type, cluster_ID: cluster_ID})}

			context "if group_ID is set and entity_type is not" do
				(:cluster_ID)	{ nil }
				(:entity_type)	{'hosts'}
				it_behaves_like 'Errors'
			
			end

			context "if entity_type is set and group_ID is not" do
				(:cluster_ID)	{''}
				(:entity_type)	{ nil }
				it_behaves_like 'Errors'
			
			end

		end
	end

	describe "#get_cluster_capacity" do
		context "will return cluster capacity" do
		end
	end

	describe "#compare_market" do
		context "will return comparison data for a market" do
			context "for host comparison" do
			end
			context "for storage comparison" do
			end
		end
	end

	describe "#compare_group" do
		context "will return comparison data for a group" do
		end
	end

	describe "#get_optimal_zone" do
		context "will get the data for the Optimal Operation Zone" do
		end
	end
end