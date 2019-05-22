# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

User.create!(email:    "abc@def.com",
             password: "pw123",
             name:     "Abc Def",
             address:  "123 Abc St",
             city:     "NYC",
             state:    "NY",
             zip:      "12345",
             role:     :merchant
            )
User.create!(email:    "zebra@zebra.com",
             password: "pw123",
             name:     "Abc Def",
             address:  "123 Abc St",
             city:     "NYC",
             state:    "NY",
             zip:      "12345",
             role:     :admin
            )