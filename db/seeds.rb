# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Post.destroy_all
User.destroy_all

user_1 = User.create!(first_name: 'John', last_name: 'Doe', email: 'john@gmail.com', password: '12341234')
user_2 = User.create!(first_name: 'Jane', last_name: 'Doe', email: 'jane@gmail.com', password: '12341234')

(1..5).each do |i|
  Post.create!(title: "Post #{i} by John", body: "Body of Post #{i} by John", user_id: user_1.id )
end

(1..5).each do |i|
  Post.create!(title: "Post #{i} by Jane", body: "Body of Post #{i} by Jane", user_id: user_2.id )
end