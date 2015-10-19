defmodule PinElixir.Charges do
  defstruct [:amount, :currency, :description, :email, :ip_address, :card]


  @pin_url PinElixir.Support.get_config(:pin_url)
  @api_key PinElixir.Support.get_config(:api_key)

  def get_all do
    response = HTTPotion.get(charges_url, [basic_auth: {@api_key, ""}])
    response
  end

  def create(charge_map) do
    json = Poison.encode!(charge_map)

    request = HTTPotion.post(charges_url, [basic_auth: {@api_key, ""}, headers: ["Content-Type": "application/json"], body: json ])
  end

  def charges_url do
    "https://#{@pin_url}/charges"
  end

end
