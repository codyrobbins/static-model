Static Model
============

This is a compilation of some boilerplate code for a non–database-backed model based on ActiveModel. You might want to use this kind of static model for anything that needs to be validated but doesn’t persist to the database—such as a login authenticator or an account password reset initiator. It includes the appropriate ActiveModel modules, has a constructor that initializes attributes from a hash, and has some helper methods useful for implementing custom validations.

Full documentation is at [RubyDoc.info](http://rubydoc.info/gems/static-model).

Example
-------

A user lookup class like the one below could be used as the parent class for a login authenticator or an account password reset initiator. It needs to find a user via their email, which entails validating the presence of the email attribute and providing access to the user that’s consequently looked up.

    class UserLookup < StaticModel
      # An accessor to allow specifying the email to look up.
      attr_accessor(:email)

      # A reader to allow access to the user that's looked up.
      attr_reader(:user)

      # Require the email attribute.
      validates(:email,
                :presence => {:message => 'Email is required.'})

      # If the email is present, ensure that a user is associated with it.
      validate do
        no_other_errors? && user_exists?
      end

      # Find the user.
      def user
        User.find_by_email(@email)
      end

      # Add an error if no user is found.
      def user_exists?
        user ? true : add_email_error_and_return_false
      end

      protected

      # Add an error.
      def add_email_error_and_return_false
        add_error_and_return_false('Email not found', :email)
      end
    end

To use this class in a Rails controller, you’d do something like

    class UserLookupController < ApplicationController
      def find
        create_user_lookup
        do_something if email_valid?
      end

      protected

      def create_user_lookup
        @user_lookup = UserLookup.new(params[:user_lookup])
      end

      def do_something
        @user_lookup.user.do_something
      end

      def email_valid?
        request.post? && @user_lookup.valid?
      end
    end

Colophon
--------

### See also

If you like this gem, you may also want to check out [Active Model Email Validator](http://codyrobbins.com/software/active-model-email-validator), [Email Test Helpers](http://codyrobbins.com/software/email-test-helpers), or [HTTP Error](http://codyrobbins.com/software/http\
-error).

### Tested with

* ActiveModel 3.0.5 — 20 May 2011

### Contributing

* [Source](https://github.com/codyrobbins/static-model)
* [Bug reports](https://github.com/codyrobbins/static-model/issues)

To send patches, please fork on GitHub and submit a pull request.

### Credits

© 2011 [Cody Robbins](http://codyrobbins.com/). See LICENSE for details.

* [Homepage](http://codyrobbins.com/software/static-model)
* [My other gems](http://codyrobbins.com/software#gems)
* [Follow me on Twitter](http://twitter.com/codyrobbins)