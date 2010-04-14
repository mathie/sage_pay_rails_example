require 'spec_helper'

describe Currency do
  it "should work fresh from the factory" do
    # Do it a few times to be sure we're not falling foul of uniqueness constraints
    3.times do
      lambda {
        Factory(:currency).should be_valid
      }.should_not raise_error
    end
  end

  describe "validations" do
    it { should validate_presence_of   :name                  }
    it { should validate_uniqueness_of :name                  }
    it { should validate_length_of     :name, :maximum => 254 }

    it { should validate_presence_of   :iso_code           }
    it { should validate_uniqueness_of :iso_code, "DDD"    }
    it { should validate_length_of     :iso_code, :is => 3 }

    it { should     validate_presence_of   :symbol                }
    it { should_not validate_uniqueness_of :symbol, "$"           }
    it { should     validate_length_of     :symbol, :maximum => 3 }
  end
end
