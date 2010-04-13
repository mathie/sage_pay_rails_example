class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name,     :null => false
      t.string :symbol,   :null => false, :length => 2 # Padding for (unnecessary) character encoding paranoia.
      t.string :iso_code, :null => false, :length => 3

      t.timestamps
    end

    add_index :currencies, :name,     :unique => true
    add_index :currencies, :symbol,   :unique => true
    add_index :currencies, :iso_code, :unique => true
  end

  def self.down
    remove_index :currencies, :column => :iso_code
    remove_index :currencies, :column => :symbol
    remove_index :currencies, :column => :name
    drop_table :currencies
  end
end