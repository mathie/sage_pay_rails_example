class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name,     :null => false
      t.string :iso_code, :null => false, :length => 2

      t.timestamps
    end

    add_index :countries, :name,     :unique => true
    add_index :countries, :iso_code, :unique => true
  end

  def self.down
    remove_index :countries, :column => :iso_code
    remove_index :countries, :column => :name
    drop_table :countries
  end
end