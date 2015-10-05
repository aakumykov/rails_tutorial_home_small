require 'spec_helper'

describe 'Аутентификация,' do

	subject { page }

	let(:signin_title) { 'Sign in' }

	describe 'страница входа,' do

		before { visit signin_path }

		it { should have_title(signin_title) }
		it { should have_content('Вход на сайт') }

		describe 'с неверными аутентификационными данными,' do
			before { click_button 'Sign in' }
			
			#expect(page).to have_title('Sign in')
			it { should have_title(signin_title) }
			it { should have_selector('div.alert.alert-error') }

			describe 'после перехода на другую страницу,' do
				before { click_link "Home" }
				 it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe 'с верными аутентификационными данными,' do
			let(:user) { FactoryGirl.create(:user) }
			
			before do
				fill_in "Email",    with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_title(user.name) }
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Settings',    href: edit_user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe 'последующий выход,' do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end

	end

	describe 'авторизация,' do
		
		describe 'для невошедших пользователей,' do
			let(:user) { FactoryGirl.create(:user) }

			describe 'в контроллере Users,' do

				describe 'посещение страницы редактирования профиля,' do
					before(:each) { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe 'отправка данных в действие update,' do
					before(:each) { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end
		end

		describe 'для ложных пользователей,' do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: SecureRandom.uuid+"@example.com") }
			before(:each) { sign_in user, no_capybara: true }

			describe 'отправка GET-запроса к Users#edit' do
				before(:each) { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Обновление вашего профиля')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe 'отправка PATCH-запроса к Users#update' do
				before(:each) { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

	end # авторизация конец

end