module ValidationMatchers

  class ValidateBase
    attr_reader :attribute, :target, :attribute_value

    def initialize(attribute)
      @attribute = attribute
    end

    def matches?(target)
      @target = target.class
      prerequisites

      examples.all? { |example| example.valid? } && counter_examples.all? { |counter_example| !counter_example.valid? && counter_example.errors.on(column_name).present? }
    end

    protected

    def prerequisites
    end

    def target_instance
      @target_instance ||= build(attribute => attribute_value)
    end

    def examples
      []
    end

    def counter_examples
      [target_instance]
    end

    def build(overrides = {})
      Factory.build(factory_name, overrides)
    end

    def create(overrides = {})
      Factory(factory_name, overrides)
    end

    def factory_name
      target.name.underscore
    end

    def column_name
      if target.column_names.include?("#{attribute}_id")
        "#{attribute}_id".to_sym
      else
        attribute
      end
    end
  end

  class ValidatePresenceOf < ValidateBase
    def description
      "validate presence of #{attribute}"
    end

    def failure_message_for_should
      "expected #{target.name} to require the presence of #{attribute}"
    end

    def failure_message_for_should_not
      "expected #{target.name} not to require the presence of #{attribute}"
    end

    protected
    def attribute_value
      if target.column_names.include?("#{attribute.to_s}_id")
        nil
      else
        ""
      end
    end
  end

  def validate_presence_of(attribute)
    ValidatePresenceOf.new(attribute)
  end

  class ValidateUniquenessOf < ValidateBase
    def initialize(attribute, duplicate_value = "Duplicate")
      super(attribute)
      @attribute_value = duplicate_value
    end

    def prerequisites
      create(attribute => attribute_value)
    end

    def description
      "validate uniqueness of #{attribute}"
    end

    def failure_message_for_should
      "expected #{target.name} to validate uniqueness of #{attribute}"
    end

    def failure_message_for_should_not
      "expected #{target.name} not to validate uniqueness of #{attribute}"
    end
  end

  def validate_uniqueness_of(attribute, duplicate_value = "Duplicate")
    ValidateUniquenessOf.new(attribute, duplicate_value)
  end

  class ValidateLengthOf < ValidateBase
    attr_reader :constraints

    def initialize(attribute, constraints)
      super(attribute)
      @constraints = constraints
    end

    def description
      "validate length of #{attribute}"
    end

    def failure_message_for_should
      "expected #{target.name} to validate length of #{attribute}"
    end

    def failure_message_for_should_not
      "expected #{target.name} not to validate length of #{attribute}"
    end

    protected
    def examples
      example_lengths.map { |length| build(attribute => 'a' * length) }
    end

    def counter_examples
      counter_example_lengths.map { |length| build(attribute => 'a' * length) }
    end

    def example_lengths
      returning [] do |valid|
        if constraints[:is].present?
          valid << constraints[:is]
        else
          if constraints[:maximum].present?
            valid << constraints[:maximum] - 1
            valid << constraints[:maximum]
          end

          if constraints[:minimum].present?
            valid << constraints[:minimum]
            valid << constraints[:minimum] + 1
          end
        end
      end
    end

    def counter_example_lengths
      returning [] do |invalid|
        if constraints[:is].present?
          invalid << constraints[:is] + 1
          invalid << constraints[:is] - 1
        else
          if constraints[:maximum].present?
            invalid << constraints[:maximum] + 1
          end

          if constraints[:minimum].present?
            invalid << constraints[:minimum] - 1
          end
        end
      end
    end
  end

  def validate_length_of(attribute, constraints)
    ValidateLengthOf.new(attribute, constraints)
  end
end