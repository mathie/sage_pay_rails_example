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
    describe "on #name" do
      it "should validate its presence" do
        currency = Factory.build(:currency, :name => "")
        currency.should_not be_valid
        currency.should have(1).error_on(:name)
      end

      it "should validate its uniqueness" do
        Factory(:currency, :name => "Duplicate")
        duplicate = Factory.build(:currency, :name => "Duplicate")
        duplicate.should_not be_valid
        duplicate.should have(1).error_on(:name)
      end

      it "should validate the length being <= 254 characters" do
        currency = Factory.build(:currency, :name => "f" * 254)
        currency.should be_valid

        currency = Factory.build(:currency, :name => "f" * 255)
        currency.should_not be_valid
        currency.should have(1).error_on(:name)
      end
    end

    describe "on #iso_code" do
      it "should validate its presence" do
        currency = Factory.build(:currency, :iso_code => "")
        currency.should_not be_valid
        currency.should have(1).error_on(:iso_code)
      end

      it "should validate its uniqueness" do
        Factory(:currency, :iso_code => "DUP")
        duplicate = Factory.build(:currency, :iso_code => "DUP")
        duplicate.should_not be_valid
        duplicate.should have(1).error_on(:iso_code)
      end

      it "should validate the length being exactly 3 characters" do
        currency = Factory.build(:currency, :iso_code => "D" * 3)
        currency.should be_valid

        currency = Factory.build(:currency, :iso_code => "D" * 2)
        currency.should_not be_valid
        currency.should have(1).error_on(:iso_code)

        currency = Factory.build(:currency, :iso_code => "D" * 4)
        currency.should_not be_valid
        currency.should have(1).error_on(:iso_code)
      end
    end

    describe "on #symbol" do
      it "should validate its presence" do
        currency = Factory.build(:currency, :symbol => "")
        currency.should_not be_valid
        currency.should have(1).error_on(:symbol)
      end

      it "should not require it to be unique" do
        Factory(:currency, :symbol => "$")
        duplicate = Factory.build(:currency, :symbol => "$")
        duplicate.should be_valid
      end

      it "should validate the length being <= 3 characters" do
        currency = Factory.build(:currency, :symbol => "HK$")
        currency.should be_valid

        currency = Factory.build(:currency, :symbol => "£")
        currency.should be_valid

        currency = Factory.build(:currency, :symbol => "D" * 4)
        currency.should_not be_valid
        currency.should have(1).error_on(:symbol)
      end
    end
  end
end
