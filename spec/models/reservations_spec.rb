require 'spec_helper'

describe Reservation do
	subject(:reservation) { Reservation.new(vmt_userid, vmt_password, vmt_url) }
	let(:vmt_userid) 	{ VMT_USERID }
	let(:vmt_password)	{ VMT_PASSWORD}
	let(:vmt_url)		{ VMT_BASE_URL }

	describe "Should be a valid VMT Object" do
		it_behaves_like 'a VMT API object'
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

			it "will return a populated hash" do
				expect(data_result.length).to be >= 1
			end
		end
	end

	describe "#get_reservation_details" do
		let(:reservation_ID)	{'_0ZyMkOhGEeS2kPR885AurA'}
		let(:data_result)		{reservation.get_reservation(reservation_ID)}
		it "will return reservation details" do
			expect(data_result.length).to be >= 1
		end
	end

end