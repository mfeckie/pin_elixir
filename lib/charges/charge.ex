defmodule PinElixir.Charge do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response

  @moduledoc """
  Handles the creation and retrieval of charges
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)

  @doc """
  Retreives all charges

  Returns a tuple


  ```
  {:ok,
   %{charges: [%{amount: 500, amount_refunded: 0, authorisation_expired: false,
        captured: true,
        card: %{address_city: "Hogwarts", address_country: "Straya",
          address_line1: "The Game Keepers Cottage", address_line2: nil,
          address_postcode: "H0G", address_state: "WA",
          customer_token: "cus_uie_Z4FA-FWn2hIHfTlHoA",
          display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
          expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
          token: "card_i-DSgMjhcwRi_dInriNBTw"},
        created_at: "2015-11-15T08:33:04Z", currency: "AUD",
        description: "Dragon Eggs", email: "hagrid@hogwarts.wiz",
        error_message: nil, ip_address: "127.0.0.1", merchant_entitlement: 455,
        refund_pending: false, settlement_currency: "AUD",
        status_message: "Success", success: true,
        token: "ch_SQG0cSfE3AytQKRVAHMFNg", total_fees: 45, transfer: []},
        %{amount: ...}],
       pagination: %{count: 42, current: 1, next: 2, pages: 2, per_page: 25,
         previous: nil}}}
    ```

  OR

      {:error, error_map}

  """
  def get_all do
    HTTPotion.get(charges_url, with_auth)
    |> handle_get_all
  end

  defp handle_get_all(%{status_code: 200, body: body}) do
    decode(body)
    |> rename_response_field
    |> wrap_in_success_tuple
  end

  defp handle_get_all(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp rename_response_field(response) do
    %{charges: response.response,
      pagination: response.pagination}
  end

  defp wrap_in_success_tuple(map) do
    {:ok, map}
  end

  @doc """
    Given a charge token returns a tuple representing the charge

    ```
    {:ok,
     %{charge: %{amount: 500, amount_refunded: 0, authorisation_expired: false,
         captured: true,
         card: %{address_city: "Hogwarts", address_country: "Straya",
           address_line1: "The Game Keepers Cottage", address_line2: nil,
           address_postcode: "H0G", address_state: "WA",
           customer_token: "cus_uie_Z4FA-FWn2hIHfTlHoA",
           display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
           expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
           token: "card_i-DSgMjhcwRi_dInriNBTw"},
         created_at: "2015-11-15T08:33:04Z", currency: "AUD",
         description: "Dragon Eggs", email: "hagrid@hogwarts.wiz",
         error_message: nil, ip_address: "127.0.0.1", merchant_entitlement: 455,
         refund_pending: false, settlement_currency: "AUD",
         status_message: "Success", success: true,
         token: "ch_SQG0cSfE3AytQKRVAHMFNg", total_fees: 45, transfer: []}}}
    ```

    OR

    ```
    {:error, error_details}
    ```
  """

  def get(token) do
    HTTPotion.get(charges_url <> "/#{token}", with_auth)
    |> handle_get
  end

  defp handle_get(%{status_code: 200, body: body}) do
    decoded = decode(body)
    {:ok, %{charge: decoded.response}}
  end

  defp handle_get(%{status_code: 404, body: body}) do
    body |> to_error_tuple
  end

  @doc """
  Takes a map representing a customer charge to create a charge

  Can be used with a card, customer_token or card_token key

  **Note that amount is in the base unit of the currency, e.g $5 would be represented by an amout of 500 (cents)**

  ```
  charge = %{
    amount: 500,
    currency: "AUD", # Optional (default: "AUD")
    description: "Dragon Eggs",
    email: "hagrid@hogwarts.wiz",
    ip_address: "127.0.0.1",
    card: %{
      number: 4200000000000000,
      expiry_month: "10",
      expiry_year: 2016,
      cvc: 456,
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      address_city: "Hogwarts",
      address_postcode: "H0G",
      address_state: "WA",
      address_country: "England"
    }
  }

  Charge.create(charge)
  ```

  ```
  charge = %{
    amount: 500,
    currency: "AUD", # Optional (default: "AUD")
    description: "Dragon Eggs",
    email: "hagrid@hogwarts.wiz",
    ip_address: "127.0.0.1"
    card_token: "abcd123"
  }
  Charge.create(charge)
  ```

  ```
  charge = %{
    amount: 500,
    currency: "AUD", # Optional (default: "AUD")
    description: "Dragon Eggs",
    email: "hagrid@hogwarts.wiz",
    ip_address: "127.0.0.1"
    customer_token: "cust_123"
  }
  Charge.create(charge)
  ```

  returns a tuple representing the outcome of the charge

  ```
  {:ok,
   %{charge: %{amount: 500, amount_refunded: 0, authorisation_expired: false,
       captured: true,
       card: %{address_city: "Hogwarts", address_country: "Straya",
         address_line1: "The Game Keepers Cottage", address_line2: nil,
         address_postcode: "H0G", address_state: "WA",
         customer_token: "cus_uie_Z4FA-FWn2hIHfTlHoA",
         display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
         expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
         token: "card_i-DSgMjhcwRi_dInriNBTw"},
       created_at: "2015-11-15T08:33:04Z", currency: "AUD",
       description: "Dragon Eggs", email: "hagrid@hogwarts.wiz",
       error_message: nil, ip_address: "127.0.0.1", merchant_entitlement: 455,
       refund_pending: false, settlement_currency: "AUD",
       status_message: "Success", success: true,
       token: "ch_SQG0cSfE3AytQKRVAHMFNg", total_fees: 45, transfer: []}}}
  ```

  OR

      {:error, error_message}
  """

  def create(%{charge: charge, card: card}) do
    Poison.encode!(Map.put(charge, :card, card))
    |> post_to_api
    |> handle_charge_response
  end

  def create(%{charge: charge, customer_token: customer_token}) do
    Poison.encode!(Map.put(charge, :customer_token, customer_token))
    |> post_to_api
    |> handle_charge_response
  end

  def create(%{charge: charge, card_token: card_token}) do
    Poison.encode!(Map.put(charge, :card_token, card_token))
    |> post_to_api
    |> handle_charge_response
  end

  defp post_to_api(json) do
    HTTPotion.post(charges_url, with_auth([headers: ["Content-Type": "application/json"], body: json]))
  end

  defp handle_charge_response(%{status_code: 201, body: body}) do
    decode(body)
    |> rename_charge_field
    |> wrap_in_success_tuple
  end

  defp handle_charge_response(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp rename_charge_field(map) do
    %{charge: map.response}
  end

  @doc """
  Given a token, processes a previously authorized payment

  returns a tuple

  ```
  {:ok,
   %{charge: %{amount: 500, amount_refunded: 0, authorisation_expired: false,
       captured: true,
       card: %{address_city: "Hogwarts", address_country: "Straya",
         address_line1: "The Game Keepers Cottage", address_line2: nil,
         address_postcode: "H0G", address_state: "WA",
         customer_token: "cus_uie_Z4FA-FWn2hIHfTlHoA",
         display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
         expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
         token: "card_i-DSgMjhcwRi_dInriNBTw"},
       created_at: "2015-11-15T07:51:05Z", currency: "AUD",
       description: "Dragon Eggs", email: "hagrid@hogwarts.wiz",
       error_message: nil, ip_address: "127.0.0.1", merchant_entitlement: 455,
       refund_pending: false, settlement_currency: "AUD",
       status_message: "Success", success: true,
       token: "ch_NCoA7oBzrycXEPBTEUWNdQ", total_fees: 45, transfer: []}}}
  ```

  OR

      {:error, error_map}
  """

  def capture(token) do
    HTTPotion.put(charges_url <> "/#{token}/capture", with_auth)
    |> handle_charge_response
  end

  defp charges_url do
    "https://#{@pin_url}/charges"
  end

end
