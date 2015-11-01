defmodule PinElixir.Card do
  defstruct [:number, :expiry_month, :expiry_year,
             :cvc, :name, :address_line1, :address_postcode,
             :address_city, :address_state, :address_country,
             :token, :scheme, :display_number]

  def from_map(string_key_map) do
    atomic = for {key, value} <- string_key_map,
    into: %{},
    do: {String.to_atom(key), value}
    to_struct(atomic)
  end

  defp to_struct(map) do
    struct(PinElixir.Card, map)
  end

end
