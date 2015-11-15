defmodule PinElixir.Card do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response
  @moduledoc """
  Provides the ability to create tokens from credit cards
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)

  @doc """
  Given a card map, creates a card token.

  Returns a tuple

  ```
  {:ok,
  %{card: %{address_city: "Hogwarts", address_country: "Straya",
     address_line1: "The Game Keepers Cottage", address_line2: nil,
     address_postcode: "H0G", address_state: "WA", customer_token: nil,
     display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10, expiry_year: 2016,
     name: "Rubius Hagrid", primary: nil, scheme: "visa",
     token: "card_hK8nB6YEyDQKz0swg8C_6Q"}}}
   ```

   OR

   ```
   {:error, error_map}
   ```
  """

  def create(card_map) do
    json = Poison.encode!(card_map)
    HTTPotion.post(card_url, with_auth(headers: ["Content-Type": "application/json"], body: json))
    |> handle_create
  end

  defp handle_create(%{status_code: 201, body: body}) do
    decoded = decode(body)
    {:ok, %{card: decoded.response}}
  end

  defp handle_create(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp card_url do
    "https://#{@pin_url}/cards"
  end
end
