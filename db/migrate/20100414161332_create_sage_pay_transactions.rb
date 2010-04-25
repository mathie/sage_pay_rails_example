class CreateSagePayTransactions < ActiveRecord::Migration
  def self.up
    create_table :sage_pay_transactions do |t|
      t.string     :vendor
      t.string     :security_key
      t.references :payment,        :null => false

      t.timestamps
    end

    add_index :sage_pay_transactions, :payment_id
  end

  def self.down
    remove_index :sage_pay_transactions, :payment_id
    drop_table :sage_pay_transactions
  end
end
