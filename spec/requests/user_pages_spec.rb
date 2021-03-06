require 'spec_helper'

describe "Страницы пользователя," do

  subject { page }

	describe 'страница профиля,' do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
	 
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }

		describe 'микросообщения,' do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }      
		end

		describe 'кнопки follow/unfollow,' do
			let(:other_user) { FactoryGirl.create(:user) }
			before { sign_in user }

			describe 'следование за пользователем,' do
				before { visit user_path(other_user) }

				it 'должно увеличиваться количество авторов пользователя,' do
					expect do
						click_button 'Follow'
					end.to change(user.author_users, :count).by(1)
				end

				it 'должно увеличиваться количество читателей автора,' do
					expect do
						click_button 'Follow'
					end.to change(other_user.reader_users, :count).by(1)
				end

				describe 'изменение вида кнопки на "Unfollow",' do
					before { click_button 'Follow' }
						it { should have_xpath("//input[@value='Unfollow']") }
					end
				end

			describe 'прекращение следования,' do
				before do
					user.read!(other_user)
					visit user_path(other_user)
				end

				it 'должно уменьшаться количество авторов пользователя,' do
					expect do
						click_button 'Unfollow'
					end.to change(user.author_users, :count).by(-1)
				end

				it 'должно уменьшаться количество читателей автора,' do
					expect do
						click_button 'Unfollow'
					end.to change(other_user.reader_users, :count).by(-1)
				end

				describe 'изменение вида кнопки на "Follow",' do
					before { click_button 'Unfollow' }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end
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
		  fill_in "Имя",         with: "Example User"
		  fill_in "Электронная почта",        with: "user@example.com"
		  fill_in "Пароль",     with: "foobar"
		  fill_in "Подтверждение пароля", with: "foobar"
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


	describe 'страница редактирования,' do
		
		let(:save_button) {'Сохранить изменения'}

		let(:user) { FactoryGirl.create(:user) }
		
		before(:each) {
			sign_in user
			visit edit_user_path(user)
		}

		describe 'страница,' do
			it { should have_title("Редактирование пользователя") }
			it { should have_content("Обновление вашего профиля") }
			it { should have_link('изменить', href: 'http://gravatar.com/emails') }
		end

		describe 'с ложными данными,' do
			before { click_button save_button }

			it { should have_content('error') }
		end

		describe 'с верными данными,' do
			let(:new_name)  { "New Name" }
			let(:new_email) { "new@example.com" }
			
			before do
				fill_in "Имя",             with: new_name
				fill_in "Электронная почта",            with: new_email
				fill_in "Пароль",         with: user.password
				fill_in "Подтверждение пароля", with: user.password
				click_button save_button
			end

			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
		end
	end


	describe 'список пользователей,' do
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
			FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
			visit users_path
		end

		it { should have_title('Список пользователей') }
		it { should have_content('Список пользователей') }

		describe 'разбиение на страницы,' do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all)  { User.delete_all }

			it { should have_selector('div.pagination') }

			it 'должны отображаться все пользователи,' do
				User.paginate(page: 1).each do |user|
					#expect(page).to have_selector('a', text: user.name)
					expect(page).to have_selector('li')
				end
			end
		end

		describe 'ссылки удаления пользователей,' do

			it { should_not have_link('удалить') }

			describe 'режим администратора,' do
				
				let(:admin) { FactoryGirl.create(:admin) }
				
				before(:each) do
					sign_in admin
					visit users_path
				end

				it { should have_link('удалить', href: user_path(User.first)) }
				
				it 'должен мочь удалить другого пользователя,' do
					expect {
						click_link('удалить', match: :first)
					}.to change(User, :count).by(-1)
				end
				
				# у админа не должно быть ссылки на удаление самого себя
				it { should_not have_link('удалить', href: user_path(admin)) }

				describe 'он не должен мочь удалить себя в обход ссылки!' do
					before { sign_in admin, no_capybara: true }
					specify { expect { delete user_path(admin) }.not_to change(User, :count) }
				end
			end
		end
	end
  

	describe 'просмотр профиля несуществующего пользователя,' do
		let(:user) { FactoryGirl.create(:user) }
  		
  		before(:each) do
  			sign_in user, no_capybara: true
  		end

  		describe 'перенаправление к списку пользователей,' do
  			before(:each) do
	  			get user_path(User.last.id+1)
	  		end
  			specify { expect(response).to redirect_to(users_path) }
  		end

  		describe 'уведомление об ошибке,' do
  			before(:each) do
	  			visit user_path(User.last.id+1)
	  		end
  			specify { expect(page).to have_selector('div.alert') }
  		end
  	end


  	describe 'запрещённые атрибуты,' do
  		let(:user) { FactoryGirl.create(:user) }
  		let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
  		before do
  			sign_in user, no_capybara: true
  			patch user_path(user), params
  		end
  		specify { expect(user.reload).not_to be_admin }
  	end


  	describe 'прямой доступ зарегистрированных к Users,' do
		let(:user) { FactoryGirl.create(:user) }
		let(:params) {
			{ user: { 
				name: 'Somebody', 
				email: 'somebody@example.com',
				password: '123456', 
				password_confirmation: '123456', 
			} }
		}
  		
  		before(:each) do
  			sign_in user, no_capybara: true
  		end

  		describe '#create,' do
  			specify { expect { post users_path, params }.not_to change(User, :count) }
  		end

  		describe '#new' do
  			before { get signup_path }
  			specify { expect(response).to redirect_to(root_path) }
  		end
  	end


	describe 'авторы/читатели,' do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		
		before { user.read!(other_user) }

		describe 'авторы,' do
			before do
				sign_in user
				visit authors_user_path(user)
			end

			it { should have_title(full_title('Авторы')) }
			it { should have_selector('h3', text: 'Авторы') }
			it { should have_link(other_user.name, href: user_path(other_user)) }
		end

		describe 'читатели,' do
			before do
				sign_in other_user
				visit readers_user_path(other_user)
			end

			it { should have_title(full_title('Читатели')) }
			it { should have_selector('h3', text: 'Читатели') }
			it { should have_link(user.name, href: user_path(user)) }
		end
	end
end
