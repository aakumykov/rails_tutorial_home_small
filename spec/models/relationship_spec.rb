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

	describe 'когда отсутствует followed_id,' do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe 'когда отсутствует follower_id,' do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end

	
end
