require 'spec_helper'

describe Address do
  it "should work straight from the factory" do
    3.times do
      lambda { Factory(:address).should be_valid }.should_not raise_error
    end
  end

  describe "validations" do
    it { should     validate_presence_of :first_names                   }
    it { should     validate_length_of   :first_names,  :maximum =>  20 }

    it { should     validate_presence_of :surname                       }
    it { should     validate_length_of   :surname,      :maximum =>  20 }

    it { should     validate_presence_of :address_1                     }
    it { should     validate_length_of   :address_1,    :maximum => 100 }

    it { should_not validate_presence_of :address_2                     }
    it { should     validate_length_of   :address_2,    :maximum => 100 }

    it { should     validate_presence_of :city                          }
    it { should     validate_length_of   :city,         :maximum =>  40 }

    it { should     validate_presence_of :post_code                     }
    it { should     validate_length_of   :post_code,    :maximum =>  10 }

    it { should     validate_presence_of :country                       }

    it { should_not validate_presence_of :state                         }
    it { should     validate_length_of   :state,        :maximum =>   2 }

    it { should_not validate_presence_of :phone                         }
    it { should     validate_length_of   :phone,        :maximum =>  20 }
  end
end
