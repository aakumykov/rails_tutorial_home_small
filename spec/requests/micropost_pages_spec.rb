require 'spec_helper'

describe 'Страницы микросообщений,' do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }

	before(:each) { sign_in user }

	describe 'создание микросообщения,' do
		before(:each) { visit root_path }

		describe 'с неверными данными,' do
			
			it 'микросообщение не должно создаваться,' do
				expect { click_button 'Отправить' }.not_to change(Micropost, :count)
			end

			describe 'должно появиться сообщение об ошибке,' do
				before { click_button 'Отправить' }
				it { should have_content('error') }
			end
		end

		describe 'с верными данными,' do
			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			
			it 'должно создаваться микросообщение,' do
				expect { click_button 'Отправить' }.to change(Micropost, :count).by(1)
			end
		end
	end

end
