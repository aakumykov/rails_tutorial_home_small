require 'spec_helper'

describe User do

	before do
		@user = User.new(
			name: "Example User", 
			email: "user@example.com",
			password: 'qwerty',
			password_confirmation: 'qwerty',
		)
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }
	it { should respond_to(:relationships) }

	it { should be_valid }
	it { should_not be_admin }

	describe 'когда отсутствует имя' do
		before { @user.name = ' ' }
		it { should_not be_valid }
	end

	describe 'когда отсутствует email' do
		before { @user.email = ' ' }
		it { should_not be_valid }
	end

	describe 'когда имя слишком длинное' do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe 'когда неверный формат электронной почты' do
		it 'модель должна быть некорректной' do
			addresses = %w[
				user@foo,com 
				user_at_foo.org 
				example.user@foo. 
				foo@bar_baz.com 
				foo@bar+baz.com
				foo@bar..com
			]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe 'когда верный формат электронной почты' do
		it 'модель должна быть корректной' do
			addresses = %w[
				user@foo.COM 
				A_US-ER@f.b.org 
				frst.lst@foo.jp 
				a+b@baz.cn
			]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe 'когда email уже кем-то используется' do
		before do
			user2 = @user.dup
			user2.email = @user.email.upcase
			user2.save
		end
		it { should_not be_valid }
	end

	describe 'когда нет пароля' do
		before do
			@user = User.new(
				name: "Example User",
				email: "user@example.com",
				password: ' ',
				password_confirmation: ' '
			)
		end
		it { should_not be_valid }
	end

	describe 'когда пароль не совпадает с подтверждением пароля' do
		before { @user.password_confirmation = 'mismatch' }
		it { should_not be_valid }
	end

	describe 'когда пароль короток с лишком' do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe 'значение, возвращаемое методом authenticate' do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe 'с корректным паролем' do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe 'с некорректным паролем' do
			let(:user_for_invalid_password) { found_user.authenticate(SecureRandom.uuid) }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe 'электроннная почта в смешанном решистре' do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

		it 'должна сохраняться в нижнем регистре' do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end

	describe 'токен памяти' do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe 'с атрибутом "admin=true",' do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe 'связь с микросообщениями,' do
		before { @user.save }
		
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it 'правильные микросообщения должны быть в правильном порядке, ' do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it 'микросообщения должны удаляться вместе с пользователем,' do
			microposts = @user.microposts.to_a
			@user.destroy
			
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		describe 'статус,' do
			let(:unfollowed_post) do
				FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end

			its(:feed) { should include(newer_micropost) }
			its(:feed) { should include(older_micropost) }
			its(:feed) { should_not include(unfollowed_post) }
		end
	end


end