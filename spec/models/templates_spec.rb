require 'spec_helper'

describe Template do
	subject(:template) { Template.new(vmt_userid, vmt_password, vmt_url) }
	let(:vmt_userid) 	{ VMT_USERID }
	let(:vmt_password)	{ VMT_PASSWORD}
	let(:vmt_url)		{ VMT_BASE_URL }

	describe "Should be a valid VMT Object" do
		it_behaves_like 'a VMT API object'
	end

	describe "#get_template" do
		let(:entity_root) 	{'TopologyElements'}
		let(:entity_node) 	{'TopologyElement'}
		let(:entity_attr) 	{'creationClassName'}
		let(:valid_data)  	{'Reservation'}
		let(:data_result)	{template.get_template(template_ID)}
		let(:template_ID)	{ nil }
	
		context "will return a list of templates" do
			
			it_behaves_like 'return entity'
		end

		context "will return a single template by name" do
			let(:template_ID)	{'VirtualMachine::NetApp81-7mode-appliance'}

			it "will return a populated hash" do
				expect(data_result.length).to be >= 1
			end
		end
		context "will return a single template by UUID" do
			let(:template_ID)	{'_NxZosPNWEeS2kPR885AurA'}

			it "will return a populated hash" do
				expect(data_result.length).to be >= 1
			end
		end
	end
end