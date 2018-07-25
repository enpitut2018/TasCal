# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Schedule.create(
                   name: "hoge",
                   start: DateTime.new(1993, 2, 24, 11, 30, 45),
                   end: DateTime.new(1993, 2, 24, 12, 30, 45)
)
