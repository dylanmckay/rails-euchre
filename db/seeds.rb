# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
AI_NAMES = File.open("first_names.txt").lines.map(&:chomp)

AI_NAMES.each do |name|
  User.ai.create!(name: name)
end
