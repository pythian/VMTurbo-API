shared_examples_for 'a VMT API object' do
	
	describe "#IntializeClass" do
		it { expect(subject).to be subject}
	
		context "should pass three vaild parameters" do

			it "throws an exception if three parameters are not passed" do
				expect(lambda { subject("administrator", "Sysdreamworks123!")}).to raise_exception ArgumentError
			end
				
			it "passes connection string information to the class" do
				expect(subject.vmt_userid).to eql vmt_userid
				expect(subject.vmt_password).to eql vmt_password
				expect(subject.vmt_url).to eql vmt_url
			end
		end
	end
end

shared_examples_for 'a connection to VMTurbo' do

	describe "should make a connection" do
	let(:url_endpoint) {"/vmturbo/api/markets"}	

		it "will return a 200OK response" do
			response = subject.GetConnection(url_endpoint)
			expect(response.code).to eql 200
		end
	end
end

shared_examples 'a valid result' do
	it "a valid parameter type" do
		expect(subject.entity_type_check(entity_type)).to be result
	end
  
end
shared_examples 'return market' do
	it "with a valid dataset" do
		data_result = market.get_list(market_name)
		expect(data_result[entity_root][entity_node][0][entity_attr]).to eql "#{valid_data}"
	end
end

shared_examples 'return entity' do
	it "valid hash" do
		data_result = market.get_entity_list(market_name, entity_query)
		expect(data_result[entity_root][entity_node][0][entity_attr]).to eql "#{valid_data}"
	end
end

shared_examples 'Errors' do
	it "with bad entity data" do 
		
		expect{data_result}.to raise_exception ArgumentError
	end	
  
end

shared_examples 'get entity data' do
	it "will get entity data" do
		expect(data_result[entity_root][entity_node][entity_attr]).to eql "#{valid_data}"
	end
end


