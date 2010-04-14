class Country < ActiveRecord::Base
  validates_presence_of   :name, :iso_code
  validates_uniqueness_of :name, :iso_code

  validates_length_of :name,     :maximum => 254, :allow_blank => true
  validates_length_of :iso_code, :is      =>   2, :allow_blank => true
end
