require 'spec_helper'

describe Reservation do
	subject(:reservation) { Reservation.new(vmt_userid, vmt_password, vmt_url) }
	let(:vmt_userid) 	{ VMT_USERID }
	let(:vmt_password)	{ VMT_PASSWORD}
	let(:vmt_url)		{ VMT_BASE_URL }

	describe "Should be a valid VMT Object" do
		it_behaves_like 'a VMT API object'
	end

	describe "#query_builder" do
		let(:api_endpoint) 	{ "/vmturbo/api/reservations" }
		let(:state)			{"RESERVED"}

		context "will return a valid query" do
			
			it "returns a valid get_entity_list query without parameters" do
				query = reservation.query_builder(api_endpoint, nil)
				expect(query).to eql "/vmturbo/api/reservations"
			end

			it "returns a valid get_entity_list query with parameters" do
				query = reservation.query_builder(api_endpoint, {:state => state})
				expect(query).to eql "/vmturbo/api/reservations?state=#{state}"
			end
		end

	end

	describe "#get_reservation" do
		let(:entity_root) 	{'TopologyElements'}
		let(:entity_node) 	{'TopologyElement'}
		let(:entity_attr) 	{'creationClassName'}
		let(:valid_data)  	{'Reservation'}
		let(:data_result)	{reservation.get_reservation(reservation_ID)}
		let(:reservation_ID)	{ nil }
	
		context "will return a list of reservations" do
			
			it_behaves_like 'return entity'
		end

		context "will return a list of reservations with a specific state" do
			let(:data_result)	{reservation.get_reservation(reservation_ID, state)}
			let(:state)			{{:state => 'RESERVED'}}

			it_behaves_like 'return entity'
		end
	end
end