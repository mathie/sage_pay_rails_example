require 'spec_helper'

describe SagePayTransaction do
  it "should work straight from the factory" do
    3.times do
      lambda {
        Factory(:sage_pay_transaction).should be_valid
      }.should_not raise_error
    end
  end

  describe "validations" do
    it { should validate_presence_of(:vendor_tx_code) }
    it { should validate_presence_of(:vendor)         }
    it { should validate_presence_of(:vps_tx_id)      }
    it { should validate_presence_of(:security_key)   }
    it { should validate_presence_of(:payment)        }
  end
end
