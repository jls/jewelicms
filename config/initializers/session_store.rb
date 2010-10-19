# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jls_com_session',
  :secret      => '3eff682e31f4d597d9b6e972f6d8b80142a0d5ea647add40d4d3a740700289e086bc1f8f6819f031cb335ececd02417ebc3bab6d9852b7bbbf74dd7923b3ce25'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
