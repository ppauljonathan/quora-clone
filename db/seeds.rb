# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'Paul',
             email: 'admin@quoraclone.com',
             credits: 5,
             password: 'secret',
             verified_at: Time.now,
             role: 'admin')

User.create!(name: 'Jonathan',
             email: 'user@quoraclone.com',
             password: 'secret',
             credits: 5,
             verified_at: Time.now)

CreditPack.create!(price: '499.99',
                   credit_amount: '50',
                   description: 'starter pack')

CreditPack.create!(price: '949.99',
                   credit_amount: '100',
                   description: 'bonus pack')

CreditPack.create!(price: '1799.99',
                   credit_amount: '200',
                   description: 'super pack')
