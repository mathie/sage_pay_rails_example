require 'spec_helper'

describe Payment do
  it "should work straight from the factory" do
    lambda {
      Factory(:payment).should be_valid
    }.should_not raise_error
  end

  describe "on #description" do
    it "should validate its presence" do
      payment = Factory.build(:payment, :description => "")
      payment.should_not be_valid
      payment.should have(1).error_on(:description)
    end

    it "should validate the length being <= 100 characters" do
      payment = Factory.build(:payment, :description => "f" * 100)
      payment.should be_valid

      payment = Factory.build(:payment, :description => "f" * 101)
      payment.should_not be_valid
      payment.should have(1).error_on(:description)
    end
  end

end
