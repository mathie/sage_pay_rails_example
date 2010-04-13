# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sage_pay_rails_example_session',
  :secret      => '142cadefacf35a90349cf9aa4ef67395a1ea512c8d40a762cc6fbe60560448daf3dc069c98525c04beab58b0ac5df1530c188d6c948f9c3aec0df144939fffea'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
