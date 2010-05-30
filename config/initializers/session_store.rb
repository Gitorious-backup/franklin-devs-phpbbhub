# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
gitorious_yaml = YAML::load_file(File.join(Rails.root, "config/gitorious.yml"))[Rails.env]
ActionController::Base.session = {
  :key    => '_gitorious_sess',
  :secret => gitorious_yaml['cookie_secret'],
  :domain => ".#{gitorious_yaml["gitorious_host"]}",
  :expire_after => 3.weeks,
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")


Rails.application.config.session_store :active_record_store
