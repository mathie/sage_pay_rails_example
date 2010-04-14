class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :payment

  validates_presence_of :first_names, :surname, :address_1, :city, :post_code, :country_id
  validates_length_of :first_names, :maximum =>  20, :allow_blank => true
  validates_length_of :surname,     :maximum =>  20, :allow_blank => true
  validates_length_of :address_1,   :maximum => 100, :allow_blank => true
  validates_length_of :address_2,   :maximum => 100, :allow_blank => true
  validates_length_of :city,        :maximum =>  40, :allow_blank => true
  validates_length_of :post_code,   :maximum =>  10, :allow_blank => true
  validates_length_of :state,       :maximum =>   2, :allow_blank => true
  validates_length_of :phone,       :maximum =>  20, :allow_blank => true

  def full_name
    [first_names, surname].compact.join(" ")
  end
end
