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

  describe "on #currency (and #currency_id)" do
    it "should validate its presence" do
      payment = Factory.build(:payment, :currency => nil)
      payment.should_not be_valid
      payment.should have(1).error_on(:currency_id)
    end
  end

  describe "on #amount" do
    it "should validate its presence" do
      payment = Factory.build(:payment, :amount => "")
      payment.should_not be_valid
      payment.should have(1).error_on(:amount)
    end

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
