require 'spec_helper'

describe 'Micropost,' do

	let(:user) { FactoryGirl.create(:user) }
	before do
		@micropost = user.microposts.build(content: "Lorem ipsum")
	end

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }

	describe 'когда отсутствует user_id' do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end


end