module AddressesHelper
  def formatted_address(address)
    simple_format [
      address.full_name,
      address.address_1,
      address.address_2,
      address.city,
      address.state,
      address.post_code,
      address.country.name
    ].reject { |line| line.blank? }.join("\n")
  end
end
