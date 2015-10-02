require 'spec_helper'

describe "User pages," do

  subject { page }

  describe 'страница профиля,' do
    let(:user) { FactoryGirl.create(:user) }
    
    before(:each) { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end


  describe 'страница регистрации,' do

    before(:each) { visit signup_path }

    it { should have_title("Sign up") }
    it { should have_content('Страница регистрации') }

    let(:submit) { "Create my account" }

    describe 'неверно заполненная,' do
      it 'не должен создаваться пользователь,' do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe 'должно появиться сообщение об ошибках,' do
        before(:each) { click_button submit }
        it { should have_selector('#error_explanation') }
        it { should have_selector('.alert.alert-error') }
      end
    end

    describe 'верно заполненная,' do
      before(:each) do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it 'должен быть создан пользователь,' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'после регистрации,' do
        before(:each) { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('.alert.alert-success', text: 'Welcome') }
      end

    end

  end

end