class SagePayTransactionHasNotificationDetails < ActiveRecord::Migration
  def self.up
    change_table :sage_pay_transactions do |t|
      t.string  :status
      t.string  :authorisation_code
      t.boolean :avs_cv2_matched
      t.boolean :address_matched
      t.boolean :post_code_matched
      t.boolean :cv2_matched
      t.boolean :gift_aid
      t.boolean :threed_secure_ok
      t.string  :card_type
      t.string  :last_4_digits     
    end
  end

  def self.down
  end
end
