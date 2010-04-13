class Payment < ActiveRecord::Base
  belongs_to :currency

  validates_presence_of :description
  validates_length_of :description, :maximum => 100, :allow_blank => true
end
