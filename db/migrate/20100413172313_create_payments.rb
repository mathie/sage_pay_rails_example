class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal    :amount,        :null => false, :scale => 2, :precision => 8
      t.references :currency,      :null => false
      t.string     :description,   :null => false, :length => 100
      t.string     :email_address

      t.timestamps
    end

    add_index :payments, :currency_id
  end

  def self.down
    remove_index :payments, :currency_id
    drop_table :payments
  end
end