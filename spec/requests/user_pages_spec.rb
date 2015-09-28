require 'spec_helper'

describe "User pages" do

  subject { page }

  describe 'страница регистрации' do
    before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title("Sign up") }
  end

  describe 'страница профиля' do
    let(:user) { FactoryGirl.create(:user) }
    
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

end