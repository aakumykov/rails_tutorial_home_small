require 'spec_helper'

describe 'Статические страницы,' do

	subject { page }

	let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

	shared_examples_for 'all static pages' do
		it { should have_title(full_title(page_title)) }
		it { should have_selector('h1', text: heading) }
	end

	describe 'домашняя страница,' do
		before { visit root_path }

		let(:page_title) { '' }
		let(:heading)    { 'Добро пожаловать!' }
		it_should_behave_like "all static pages"
		it { should_not have_title('| Home') }

		describe 'для зарегистрированных пользователей,' do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it 'должна появиться лента пользователя,' do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
				end
			end
		end

		describe 'статистика читаемых/читающих,' do
			let(:other_user) { FactoryGirl.create(:user) }
			before do
				other_user.read!(user)
				visit root_path
			end

			it { should have_link("0 following", href: following_user_path(user)) }
			it { should have_link("1 reader_users", href: reader_users_user_path(user)) }
		end
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
			click_on 'Sign up now!'
			expect(page).to have_title(full_title('Sign up'))
		
		visit root_path

			click_on "Home"
			expect(page).to have_selector('h1','Добро пожаловать!')
			expect(page).to have_selector('h1','Учебное приложение')

			click_on "Help"
			expect(page).to have_title(full_title('Help'))

			#click_on "Sign up"
			#expect(page).to have_title(full_title('Sign up'))

			click_on "About"
			expect(page).to have_title(full_title('About Us'))
			
			click_on "Contact"
			expect(page).to have_title(full_title('Contact'))

			#click_on "News"

		#click_on "sample app"
		#expect(page).to # заполнить
	end
end