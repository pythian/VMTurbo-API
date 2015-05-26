require 'spec_helper'

describe Group do
	subject(:group) { Group.new(vmt_userid, vmt_password, vmt_url) }
	let(:vmt_userid) 	{ VMT_USERID }
	let(:vmt_password)	{ VMT_PASSWORD}
	let(:vmt_url)		{ VMT_BASE_URL }

	describe "Should be a valid VMT Object" do
		it_behaves_like 'a VMT API object'
	end

	describe "#get_group_list" do
		let(:data_result)	{group.get_group_list(group_ID)}
		let(:group_ID)	{ nil }
	
		context "will return a list of groups" do
			
			it_behaves_like 'return entity'
		end

		context "will return a single group by name" do
			let(:group_ID)	{'domain-c72'}

			it_behaves_like 'return entity'
		end
		context "will return a single group by UUID" do
			let(:group_ID)	{'d7c70eb353932647263031225d6084bfa8210460'}

			it_behaves_like 'return entity'
		end
	end

	describe "#get_group_members" do
		let(:data_result)	{group.get_group_members(group_ID)}
		let(:group_ID)	{ nil }
	
		
		context "will return members of a group by name" do
			let(:group_ID)	{'domain-c72'}

			it_behaves_like 'return entity'
		end
		context "will return members of a group by UUID" do
			let(:group_ID)	{'d7c70eb353932647263031225d6084bfa8210460'}

			it_behaves_like 'return entity'
		end

		context "will throw exception when no group ID is passed" do
			let(:group_ID) { nil }
			it_behaves_like 'Errors'
		end
	end
end