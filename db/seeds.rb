# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
AI_NAMES = File.open("first_names.txt").each_line.map(&:chomp)

if Rails.env.test?
  AI_NAMES = AI_NAMES.take(20)
end

AI_NAMES.each do |name|
  User.ai.create!(name: name)
end
