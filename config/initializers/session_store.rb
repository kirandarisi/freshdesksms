# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_freshdesksmsex_session',
  :secret      => '9fea2161daeef49d8ee6a917dc21515fce20301173c6284bfd15301058ebf0ddcc9eac4ea0a7b413a866c36a050111c110fabb326842fe41b288c5913220529b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
