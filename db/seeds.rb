# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Example User",
             email: "example@example.com",
             password: "foobar",
             password_confirmation: "foobar")

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

users = User.take(5)
users.each do |user|
  5.times do
    name = Faker::Lorem.words(rand(1..4)).join(" ").capitalize
    description = Faker::Lorem.paragraph
    user.events_as_host.create!(name: name,
                                description: description,
                                event_date: Faker::Time.forward)
  end
end

users.each do |user|
  user.events_as_host.each do |event|
    event.invites.create!(user_id: User.find_by(name: "Example User").id)
    5.times do |n|
      relevant_id = User.find_by(email: "example-#{n+1}@example.com").id
      event.invites.create!(reply: ["yes", "no", "none"][rand(0..2)],
                            user_id: relevant_id)
    end
  end
end
