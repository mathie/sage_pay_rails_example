class SagePayTransaction < ActiveRecord::Base
  belongs_to :payment

  validates_presence_of :vendor, :security_key, :payment_id
end
