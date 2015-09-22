require 'spec_helper'

describe 'Static pages' do

  subject { page }

  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  shared_examples_for 'all static pages' do
    it { should have_title("#{base_title} | #{title}") }
    it { should have_selector('h1', text: heading) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:title) { '' }
    let(:heading)    { 'Sample App' }
    it_should_behave_like "all static pages"
   
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:title) { 'Help' }
    let(:heading) {'Страница помощи'}
    it_should_behave_like 'all static pages'
  end

  describe "About page" do
  	before { visit about_path }
    let(:title) { 'About' }
    let(:heading) {'О нас'}
    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
  	before { visit contact_page }
    let(:title) { 'Contact' }
    let(:heading) {'Контакты'}
    it_should_behave_like 'all static pages'
  end
end