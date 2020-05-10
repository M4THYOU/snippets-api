# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Type.create({name: 'Theorem'})
Type.create({name: 'Definition'})

Course.create({name: 'Linear Algebra 1', code: 'Math 136'})
Course.create({name: 'Calculus 2', code: 'Math 138'})
