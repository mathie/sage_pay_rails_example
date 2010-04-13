class Currency < ActiveRecord::Base
  validates_presence_of   :name, :iso_code, :symbol
  validates_uniqueness_of :name, :iso_code

  validates_length_of :name,     :maximum => 254, :allow_blank => true
  validates_length_of :symbol,   :maximum =>   3, :allow_blank => true
  validates_length_of :iso_code, :is      =>   3, :allow_blank => true
end
