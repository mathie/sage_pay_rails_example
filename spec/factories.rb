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
