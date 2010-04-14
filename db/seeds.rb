
# Default set of currencies
Currency.find_or_create_by_iso_code(:name => "Pounds Sterling", :iso_code => "GBP", :symbol => "£")
Currency.find_or_create_by_iso_code(:name => "US Dollars",      :iso_code => "USD", :symbol => "$")
Currency.find_or_create_by_iso_code(:name => "Euros",           :iso_code => "EUR", :symbol => "€")

# Default set of countries
Country.find_or_create_by_iso_code(:name => "United Kingdom", :iso_code => "GB")
Country.find_or_create_by_iso_code(:name => "United States",  :iso_code => "US")
Country.find_or_create_by_iso_code(:name => "France",         :iso_code => "FR")
Country.find_or_create_by_iso_code(:name => "Germany",        :iso_code => "DE")
