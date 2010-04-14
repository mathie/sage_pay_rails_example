require 'spec_helper'

describe Address do
  it "should work straight from the factory" do
    3.times do
      lambda { Factory(:address).should be_valid }.should_not raise_error
    end
  end

  describe "validations" do
    
  end
end
