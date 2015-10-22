namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
	admin = User.create!(name: "Example User",
								email: "example@railstutorial.org",
								password: "123456",
								password_confirmation: "123456",
								admin: true
							)
	99.times do |n|
		name  = Faker::Name.name
		email = "example-#{n+1}@railstutorial.org"
		password  = "password"
		User.create!(name: name,
						 email:    email,
						 password: password,
						 password_confirmation: password
						)
	end
end

def make_microposts
	users = User.all(limit: 6)
	50.times do
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	users = User.all
	user  = users.first
	author_users = users[2..50]
	reader_users      = users[3..40]
	author_users.each { |author| user.read!(author) }
	reader_users.each      { |reader| reader.read!(user) }
end