require 'spec_helper'

describe "User pages" do

  subject { page }

  describe 'страница профиля' do
    let(:user) { FactoryGirl.create(:user) }
    
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end


  describe 'страница регистрации' do

    before { visit signup_path }

    it { should have_title("Sign up") }
    it { should have_content('Страница регистрации') }

    let(:submit) { "Create my account" }

    describe 'неверно заполненная' do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe 'верно заполненная' do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it 'должен быть создан пользователь' do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end