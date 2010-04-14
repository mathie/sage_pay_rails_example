require 'spec_helper'

describe Payment do
  it "should work straight from the factory" do
    lambda {
      Factory(:payment).should be_valid
    }.should_not raise_error
  end

  it { should validate_presence_of :description                  }
  it { should validate_length_of   :description, :maximum => 100 }

  it { should validate_presence_of :currency }

  it { should validate_presence_of :amount }


  describe "on #amount" do
    it "should validate that it's a number" do
      payment = Factory.build(:payment, :amount => "chickens")
      payment.should_not be_valid
      payment.should have(1).error_on(:amount)
    end

    it "should validate that the minimum value is 0.01" do
      payment = Factory.build(:payment, :amount => "-3.57")
      payment.should_not be_valid
      payment.should have(1).error_on(:amount)

      payment = Factory.build(:payment, :amount => "0.00")
      payment.should_not be_valid
      payment.should have(1).error_on(:amount)

      payment = Factory.build(:payment, :amount => "0.01")
      payment.should be_valid
    end

    it "should validate that the maximum value is 100,000.00" do
      payment = Factory.build(:payment, :amount => "99999")
      payment.should be_valid

      payment = Factory.build(:payment, :amount => "100000")
      payment.should be_valid

      payment = Factory.build(:payment, :amount => "100000.01")
      payment.should_not be_valid
      payment.should have(1).error_on(:amount)
    end
  end
end
