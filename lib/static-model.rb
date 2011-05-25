class StaticModel
  # Includes.
  include(ActiveModel::Naming)
  include(ActiveModel::Conversion)
  include(ActiveModel::Validations)

  # Methods.

  # Initializes.
  def initialize(attributes = {})
    attributes ||= {}
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # This method simply tells Rails that this model is not database-backed.
  def persisted?
    false
  end

  protected

  # Indicates whether there are currently any errors. Useful for validation methods that shouldn't fire if there are already other errors.
  def no_other_errors?
    errors.empty?
  end

  # Adds an error to the `:base` attribute and returns false so that it can halt validations chains.
  def add_error_and_return_false(error, attribute = :base)
    errors[attribute] << error
    false
  end
end
