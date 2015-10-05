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

end