require 'spec_helper'

describe Country do
  it "should work fresh from the factory" do
    # Do it a few times to be sure we're not falling foul of uniqueness constraints
    3.times do
      lambda {
        Factory(:country).should be_valid
      }.should_not raise_error
    end
  end

  describe "validations" do
    describe "on #name" do
      it "should validate its presence" do
        country = Factory.build(:country, :name => "")
        country.should_not be_valid
        country.should have(1).error_on(:name)
      end

      it "should validate its uniqueness" do
        Factory(:country, :name => "Duplicate")
        duplicate = Factory.build(:country, :name => "Duplicate")
        duplicate.should_not be_valid
        duplicate.should have(1).error_on(:name)
      end

      it "should validate the length being <= 254 characters" do
        country = Factory.build(:country, :name => "f" * 254)
        country.should be_valid

        country = Factory.build(:country, :name => "f" * 255)
        country.should_not be_valid
        country.should have(1).error_on(:name)
      end
    end

    describe "on #iso_code" do
      it "should validate its presence" do
        country = Factory.build(:country, :iso_code => "")
        country.should_not be_valid
        country.should have(1).error_on(:iso_code)
      end

      it "should validate its uniqueness" do
        Factory(:country, :iso_code => "ZZ")
        duplicate = Factory.build(:country, :iso_code => "ZZ")
        duplicate.should_not be_valid
        duplicate.should have(1).error_on(:iso_code)
      end

      it "should validate the length being exactly 2 characters" do
        country = Factory.build(:country, :iso_code => "D" * 2)
        country.should be_valid

        country = Factory.build(:country, :iso_code => "D" * 1)
        country.should_not be_valid
        country.should have(1).error_on(:iso_code)

        country = Factory.build(:country, :iso_code => "D" * 3)
        country.should_not be_valid
        country.should have(1).error_on(:iso_code)
      end
    end
  end
end
