class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal    :amount,        :null => false, :scale => 2, :precision => 8
      t.references :currency,      :null => false
      t.string     :description,   :null => false, :length => 100
      t.string     :email_address, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
