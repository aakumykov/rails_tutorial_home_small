require 'spec_helper'

describe 'Micropost,' do

	let(:user) { FactoryGirl.create(:user) }
	before do
		@micropost = user.microposts.build(content: "Lorem ipsum")
	end

	subject { @micropost }

	# проверка свойств
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }
	
	it { should be_valid }

	describe 'когда отсутствует user_id,' do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe 'когда отсутствует содержимое,' do
		before { @micropost.content = " " }
		it { should_not be_valid }
	end

	describe 'когда содержимое слишком большое,' do
		before { @micropost.content = "a" * 141 }
		it { should_not be_valid }
	end

	
end