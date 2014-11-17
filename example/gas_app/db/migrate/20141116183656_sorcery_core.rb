class SorceryCore < ActiveRecord::Migration
  def change
    add_column :producers, :crypted_password, :string
    add_column :producers, :salt, :string

    # this will automatically generate a find_by_email method!
    add_index :producers, :email, unique: true

    # set a default password to all existing producers
    Producer.find_each do |producer|
      producer.change_password!('password')
    end

    # add the NOT NULL constraint to crypted_password and salt
    change_column :producers, :crypted_password, :string, null: false
    change_column :producers, :salt, :string, null: false
  end
end