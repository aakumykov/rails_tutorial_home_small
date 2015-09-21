require 'spec_helper'

describe "Static pages" do

  subject { page }

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title("Ruby on Rails Tutorial Sample App") }
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_content('Help') }
    it { should have_title("#{base_title} | Help") }
  end

  describe "About page" do
    before { visit about_path }
    it { have_content('About Us') }
    it { have_title("#{base_title} | About Us") }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title("#{base_title} | Contact") }
  end

  describe "Signup page" do
    before { visit signup_path }
    it { should have_content('Signup') }
    it { should have_title("#{base_title} | Signup") }
  end

end