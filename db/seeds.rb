# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Tag.count == 0
  ['Meat', 'Chicken', 'Fish', 'Vegetarian', 'Vegan'].each do |name|
    Tag.create(name: name)
  end  
end

if Rails.env.development?
  if User.count == 0
    User.create(
      login: "admin",
      email: "admin@example.com",
      password: "audiences5-quislings",
      password_confirmation: "audiences5-quislings"
    )
  end
end
