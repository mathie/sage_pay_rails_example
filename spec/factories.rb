# Factory Girl builds stuff from this shed.

class Factory
  class StringSequence
    def initialize(initial, &proc)
      @proc = proc
      @previous = initial
    end

    def next
      @previous = @proc.call(@previous)
    end
  end

  class << self
    attr_accessor :string_sequences
  end
  self.string_sequences = {}

  def self.string_sequence(name, initial, &block)
    self.string_sequences[name] = StringSequence.new(initial, &block)
  end

  def self.next_string(string_sequence)
    unless self.string_sequences.key?(string_sequence)
      raise "No such string sequence: #{sequence}"
    end

    self.string_sequences[string_sequence].next
  end
end

# Currencies
Factory.string_sequence(:name, "Sealand Pongos") { |prev| prev.succ }
Factory.string_sequence(:iso_code, "ABC")        { |prev| prev.succ }
Factory.string_sequence(:symbol, "!")            { |prev| prev.succ }

Factory.define(:currency) do |currency|
  currency.name     { Factory.next_string(:name)     }
  currency.iso_code { Factory.next_string(:iso_code) }
  currency.symbol   { Factory.next_string(:symbol)   }
end

# Countries. Not quite right, but I'm stealing the name #string_sequence from
# the currency.
Factory.string_sequence(:iso_country_code, "AB") { |prev| prev.succ }

Factory.define(:country) do |country|
  country.name     { Factory.next_string(:name)             }
  country.iso_code { Factory.next_string(:iso_country_code) }
end

Factory.define(:address) do |address|
  # Address details courtesy of Faker
  address.first_names "Jaclyn"
  address.surname     "Kerluke"
  address.address_1   "798 Major Fort"
  address.city        "Falkirk"
  address.post_code   "AB12 6TB"

  address.association(:country)
  address.association(:payment)
end

# Payments
Factory.define(:payment) do |payment|
  payment.description   "Factory-generated payment description"
  payment.email_address "demo@example.com"
  payment.amount        15.99

  payment.association(:currency)
end
