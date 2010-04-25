class RecordTransactionTypeInNotification < ActiveRecord::Migration
  def self.up
    change_table :sage_pay_transactions do |t|
      t.string :transaction_type, :null => false, :default => "payment"
    end
  end

  def self.down
    change_table :sage_pay_transactions do |t|
      t.remove :transaction_type
    end
  end
end
