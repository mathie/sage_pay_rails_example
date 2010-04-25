class SagePayTransactionKeepsTransactionIds < ActiveRecord::Migration
  def self.up
    change_table :sage_pay_transactions do |t|
      t.string :our_transaction_code,  :null => false
      t.string :sage_transaction_code, :null => false
    end
    add_index :sage_pay_transactions, :our_transaction_code,  :unique => true
    add_index :sage_pay_transactions, :sage_transaction_code, :unique => true
  end

  def self.down
    remove_index :sage_pay_transactions, :our_transaction_code
    remove_index :sage_pay_transactions, :sage_transaction_code
    change_table :sage_pay_transactions do |t|
      t.remove :our_transaction_code
      t.remove :sage_transaction_code
    end
  end
end
