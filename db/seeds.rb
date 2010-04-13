
# Default set of currencies

Currency.find_or_create_by_iso_code(:name => "Pounds Sterling", :iso_code => "GBP", :symbol => "£")
Currency.find_or_create_by_iso_code(:name => "US Dollars",      :iso_code => "USD", :symbol => "$")
Currency.find_or_create_by_iso_code(:name => "Euros",           :iso_code => "EUR", :symbol => "€")
