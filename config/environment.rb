# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'sage_pay', :version => '0.2.1'

  # Stuff to make the web UI a little less painful.
  config.gem 'inherited_resources', :version => '~>1.0.6' # The 1.0.x branch is the last with Rails 2.3.x support.
  config.gem 'haml'
  config.gem 'formtastic'
  config.gem 'validation_reflection'
  config.gem 'compass'
  config.gem 'show_for', :version => '~>0.1.3'

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Edinburgh'
end
