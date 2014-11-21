class AddLatitudeAndLongitudeToProducers < ActiveRecord::Migration
  def change
    add_column :producers, :latitude, :float
    add_column :producers, :longitude, :float
  end
end
