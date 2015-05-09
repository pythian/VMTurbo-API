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