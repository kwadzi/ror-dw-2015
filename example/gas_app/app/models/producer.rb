class Producer < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :products

  validates :name, presence: true
  validates :address, presence: true
  validates :email, presence: true, uniqueness: true
  validates_confirmation_of :password, message: "Should match confirmation", if: :password

  geocoded_by :address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

end
