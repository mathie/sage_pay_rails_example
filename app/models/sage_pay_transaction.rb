class SagePayTransaction < ActiveRecord::Base
  belongs_to :payment

  validates_presence_of :vendor_tx_code, :vendor, :vps_tx_id, :security_key, :payment_id
end
