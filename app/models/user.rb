class User < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  enum status: { active: 'active', inactive: 'inactive' }

  belongs_to :role

  has_many :purchase_orders

  validates :first_name, :last_name, :role_id, :status, :email, :password, :password_confirmation, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

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
