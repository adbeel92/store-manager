class Provider < ApplicationRecord
  enum status: { new_one: 'new_one', contacted: 'contacted', active: 'active', inactive: 'inactive' }
end
