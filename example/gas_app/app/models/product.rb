class Product < ActiveRecord::Base

  belongs_to :producer

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { minimum: 0 }
  validates :unit, presence: true, inclusion: { in: %w{kg liter}, message: "%{value} is not a valid unit" }

end
