class Product < ActiveRecord::Base

  belongs_to :producer

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { minimum: 0 }
  validates :unit, presence: true, inclusion: { in: %w{kg liter}, message: "%{value} is not a valid unit" }

  has_attached_file :photo, :styles => { :medium => "300x300#", :thumb => "100x100#" }, :default_url => "/system/products/:attachment/default/:style/missing_photo.jpg"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

end
