require 'spec_helper'

describe RelationshipsController do

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { sign_in user, no_capybara: true }

	describe 'создание Отношения через AJAX,' do

		it 'должно увеличиваться число Отношений,' do
			expect do
				xhr :post, :create, relationship: { author_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		it 'должно возвращаться сообщение об успехе,' do
			xhr :post, :create, relationship: { author_id: other_user.id }
			expect(response).to be_success
		end
	end

	describe 'удаление Отнощения через AJAX,' do

		before { user.read!(other_user) }
		let(:relationship) { user.relationships.find_by(author_id: other_user) }

		it 'должно уменьшаться число Отношений,' do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		it 'должно возвращаться сообщение об успехе,' do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end
	end
end
