# Configuration options for Sage Pay Server.

# Our vendor name. Bad news, this one only works in the simulator, not
# live. :-)
SagePay::Server.default_registration_options[:vendor] = "rubaidh"

# Notification URL for pingbacks. Unfortunately, the URL helpers don't work in
# here, or this would be +notifications_url+. On the plus side, it's submitted
# as a POST, so we can pretend they meant to deliver a RESTful :create action.
# :)
SagePay::Server.default_registration_options[:notification_url] = "https://sage-pay-rails-example.heroku.com/notifications"

# Set the mode globally. Normally, you'd probably want to have different
# settings for different environments (eg :test in staging and :live in
# production) but we're pushing everything through the simulator as it's an
# example application.
SagePay::Server.default_registration_options[:mode] = :simulator

# Set the profile. If you're using iframes, chances are you want to set
# profile to :low.
SagePay::Server.default_registration_options[:profile] = :low

UUID.state_file = File.join(Rails.root, 'tmp', 'ruby-uuid')
