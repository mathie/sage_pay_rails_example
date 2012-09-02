# Sage Pay Rails Example

This is an example application to demonstrate the [sage_pay](http://github.com/mathie/sage_pay) gem
for interfacing with Sage Pay's server interface.

The current version (0.2.12) works with the same version number of the gem.

To get it working you first need to grab it:

git clone git://github.com/mathie/sage_pay_rails_example.git

Then you need to:

 1. Create a database and update database.yml with your settings
 2. rake db:migrate
 3. rake db:seed
 4. edit config/initializers/sage_pay.rb - adding your vendor ID and update the notification_url
 5. Ensure the appropriate gems are installed.
 
 That should be it!
 
 ---
 
 If you are interested in using SagePay Direct then look at dooks' modifications
 here (version 0.2.12): 
 
 https://github.com/doooks/sage_pay_rails_example/commit/4a9524ac0fb8c72b0a797c83d94719107a38c537
 
 ---
 
 # Notes
 
 If you want to use this example in your rails application then please note that it relies heavily on gems.  In particular:
 
 ## Inherited Resources
 
 Provides all standard rest actions in controlers by default.
 It also provides the following helpers in views:

 resource        #=> @project  
 collection      #=> @projects  
 resource_class  #=> Project  
 
 Please note inherited_resources has it's own dependancies.
 
 ## show_for
 
 Allows you to quickly show a model information with I18n features
 
 ## Validation Reflection
 
 Adds reflective access to validations