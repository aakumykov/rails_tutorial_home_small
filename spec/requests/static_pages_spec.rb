require 'spec_helper'

describe 'Static pages' do

  subject { page }

  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  shared_examples_for 'all static pages' do
    it { should have_title(full_title(page_title)) }
    it { should have_selector('h1', text: heading) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:page_title) { '' }
    let(:heading)    { 'Sample App' }
    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:page_title) { 'Help' }
    let(:heading) {'Страница помощи'}
    it_should_behave_like 'all static pages'
  end

  describe "About page" do
  	before { visit about_path }
    let(:page_title) { 'About' }
    let(:heading) {'О нас'}
    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
  	before { visit contact_path }
    let(:page_title) { 'Contact' }
    let(:heading) {'Контакты'}
    it_should_behave_like 'all static pages'
  end

  it "should have the right links on the layout" do
    
    visit root_path

      #click_on "Home"

      click_on "Help"
      expect(page).to have_title(full_title('Help'))

      #click_on "Sign in"
      #expect(page).to have_title(full_title('Sign up'))

      click_on "About"
      expect(page).to have_title(full_title('About Us'))
      
      click_on "Contact"
      expect(page).to have_title(full_title('Contact'))

      #click_on "News"
    
    visit root_path
      click_on 'Sign up now!'
      expect(page).to have_title(full_title('Sign up'))

    #click_on "sample app"
    #expect(page).to # заполнить
  end
end