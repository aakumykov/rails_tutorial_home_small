require 'spec_helper'

describe 'Отношения,' do
	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }

	subject { relationship }

	it { should be_valid }

	describe 'методы последователей,' do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should eq follower }
		its(:followed) { should eq followed }
	end

	
end
