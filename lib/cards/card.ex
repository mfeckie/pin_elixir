defmodule PinElixir.Card do
  defstruct [:number, :expiry_month, :expiry_year,
             :cvc, :name, :address_line1, :address_postcode,
             :address_city, :address_state, :address_country]
end
