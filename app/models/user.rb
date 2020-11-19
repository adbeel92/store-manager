class User < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  enum status: { active: 'active', inactive: 'inactive' }

  belongs_to :role

  def admin?
    role.name == 'Admin'
  end

  def manager?
    role.name == 'Manager'
  end

  def seller?
    role.name == 'Seller'
  end
end
