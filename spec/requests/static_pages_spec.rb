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
    
    click_on "About"
    expect(page).to have_title(full_title('About Us'))
    
    #click_link "Help"
    #expect(page).to # заполнить
    
    #click_link "Contact"
    #expect(page).to # заполнить
    
    #click_link "Home"
    
    #click_link "Sign up now!"
    #expect(page).to # заполнить
    
    #click_link "sample app"
    #expect(page).to # заполнить
  end
end