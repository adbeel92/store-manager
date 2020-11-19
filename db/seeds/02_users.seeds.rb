admin = Role.find_by(name: 'Admin')
User.create!(
  first_name: 'Admin',
  last_name: 'Tienda',
  status: :active,
  role: admin,
  email: 'admin@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

manager = Role.find_by(name: 'Manager')
User.create!(
  first_name: 'Manager',
  last_name: 'Tienda',
  status: :active,
  role: manager,
  email: 'manager@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

seller = Role.find_by(name: 'Seller')
User.create!(
  first_name: 'Seller',
  last_name: 'Tienda',
  status: :active,
  role: seller,
  email: 'seller@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)
