class Producer < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :products

  validates :name, presence: true
  validates :address, presence: true, uniqueness: true
  validates :email, presence: true
  validates_confirmation_of :password, message: "Should match confirmation", if: :password

end
