class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
