# encoding: UTF-8

# A compilation of some boilerplate code for a non–database-backed model based on ActiveModel. You might want to use this kind of static model for anything that needs to be validated but doesn’t persist to the database—such as a login authenticator or an account password reset initiator. It includes the appropriate ActiveModel modules, has a constructor that initializes attributes from a hash, and has some helper methods useful for implementing custom validations.
#
# Example
# -------
#
# A user lookup class like the one below could be used as the parent class for a login authenticator or an account password reset initiator. It needs to find a user via their email, which entails validating the presence of the email attribute and providing access to the user that’s consequently looked up.
#
#     class UserLookup < StaticModel
#       # An accessor to allow specifying the email to look up.
#       attr_accessor(:email)
#
#       # A reader to allow access to the user that's looked up.
#       attr_reader(:user)
#
#       # Require the email attribute.
#       validates(:email,
#                 :presence => {:message => 'Email is required.'})
#
#       # If the email is present, ensure that a user is associated with it.
#       validate do
#         no_other_errors? && user_exists?
#       end
#
#       # Find the user.
#       def user
#         User.find_by_email(@email)
#       end
#
#       # Add an error if no user is found.
#       def user_exists?
#         user ? true : add_email_error_and_return_false
#       end
#
#       protected
#
#       # Add an error.
#       def add_email_error_and_return_false
#         add_error_and_return_false('Email not found', :email)
#       end
#     end
#
# To use this class in a Rails controller, you’d do something like
#
#     class UserLookupController < ApplicationController
#       def find
#         create_user_lookup
#         do_something if email_valid?
#       end
#
#       protected
#
#       def create_user_lookup
#         @user_lookup = UserLookup.new(params[:user_lookup])
#       end
#
#       def do_something
#         @user_lookup.user.do_something
#       end
#
#       def email_valid?
#         request.post? && @user_lookup.valid?
#       end
#     end
class StaticModel
  # Includes.
  include(ActiveModel::Naming)
  include(ActiveModel::Conversion)
  include(ActiveModel::Validations)
  include(ActiveModel::Translation)

  # Methods.

  # Creates an instance of the model with its attributes initialized from a hash, just like you can do with ActiveRecord models.
  #
  # @param attributes [Hash] The attributes of the model and the respective values to initialize them with.
  #
  # @example
  #    class User < StaticModel
  #      attr_accessor(:name, :email)
  #    end
  #
  #    user = User.new(:name => 'Dagny Taggart', :email => 'dagny@taggart.com')
  #
  #    user.name  #=> Dagny Taggart
  #    user.email #=> dagny@taggart.com
  def initialize(attributes = {})
    attributes ||= {}
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # This method simply tells ActiveModel that this model is not database-backed.
  def persisted?
    false
  end

  protected

  # A helper method to be used internally by subclasses which simply indicates whether there are currently any errors. This is useful for validation methods in subclasses that shouldn’t fire if there are already other errors. For example, the format of an email address might only need to be checked if the email address is present.
  def no_other_errors?
    errors.empty?
  end

  # A helper method to be used internally by subclasses which adds an error to the `:base` attribute and returns `false` so that it can halt validations chains.
  #
  # @param error [String] The error message.
  # @param attribute [Symbol] The attribute of the model to place the error message on.
  # @return [boolean] Returns `false` in order to halt any validation chain it may be invoked from.
  def add_error_and_return_false(error, attribute = :base)
    errors[attribute] << error
    false
  end
end
