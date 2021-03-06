defmodule PinElixir.Customer do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response

  @pin_url Application.get_env :pin_elixir, :pin_url

  @moduledoc """
  Module handling customer operations
  """


  @doc """
  Given an email and card_map, creates a customer.  The map may contain a card or a card token.

  ```
  Customer.create("minerva@hogwarts.wiz", %{card_token: "abc_a123" })
  ```

  OR


  ```
  card_map = %{
    number: 4200000000000000,
    expiry_month: "10",
    expiry_year: 2016,
    cvc: 456,
    name: "Rubius Hagrid",
    address_line1: "The Game Keepers Cottage",
    address_city: "Hogwarts",
    address_postcode: "H0G",
    address_state: "WA",
    address_country: "Straya"
  }

  Customer.create("rubius@hogwarts.wiz", %{card: card_map})
  ```
  returns a tuple

  ```
  {:ok,
    %{customer: %{card: %{address_city: "Hogwarts", address_country: "Straya",
      address_line1: "The Game Keepers Cottage", address_line2: nil,
      address_postcode: "H0G", address_state: "WA",
      customer_token: "cus_JVk_KByA5JiIsSPWVKt88Q",
      display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
      expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
      token: "card_EPh4cn4-fEMeZM_osPz1dg"},
      created_at: "2015-11-15T08:40:50Z", email: "hagrid@hogwarts.wiz",
      token: "cus_JVk_KByA5JiIsSPWVKt88Q"}}}
  ```

  OR

  ```
  {:error, error_map}
  ```

  """
  def create(email, %{card: card}) do
    Poison.encode!(%{email: email, card: card})
    |> post_to_api
    |> handle_create_customer_response
  end

  def create(email, %{card_token: card_token}) do
    Poison.encode!(%{email: email, card_token: card_token})
    |> post_to_api
    |> handle_create_customer_response
  end

  defp handle_create_customer_response(%{status_code: 201, body: body}) do
    decoded = decode(body)
    {:ok, %{customer: decoded.response}}
  end

  defp handle_create_customer_response(%{status_code: 422, body: body}) do
    body |> to_error_tuple
  end

  @doc """
  Given a customer token, deletes the customer

  return a tuple

  ```
  {:ok}
  ```

  OR

  ```
  {:error, error_map}
  ```
  """

  def delete(token) do
    HTTPotion.delete(customer_url <> "/#{token}", with_auth)
    |> handle_delete
  end

  defp handle_delete(%{status_code: 200}), do: :ok

  defp handle_delete(%{status_code: 422, body: body}) do
    body |> to_error_tuple
  end

  @doc """
  Retrieves all customers

  Returns a tuple

  ```
  {:ok,
 %{customers: [%{card: %{address_city: "Hogwarts", address_country: "Straya",
        address_line1: "The Game Keepers Cottage", address_line2: nil,
        address_postcode: "H0G", address_state: "WA",
        customer_token: "cus_JVk_KByA5JiIsSPWVKt88Q",
        display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10,
        expiry_year: 2016, name: "Rubius Hagrid", primary: true, scheme: "visa",
        token: "card_EPh4cn4-fEMeZM_osPz1dg"},
      created_at: "2015-11-15T08:40:50Z", email: "hagrid@hogwarts.wiz",
      token: "cus_JVk_KByA5JiIsSPWVKt88Q"}
    ],
   pagination: %{count: 3, current: 1, next: nil, pages: 1, per_page: 25,
     previous: nil}}}
   ```

  OR

      {:error, error_map}
  """


  def get do
    HTTPotion.get(customer_url, with_auth)
    |> handle_get_all
  end

  @doc """
  Given a customer token, retrieves customer details

  Returns a tuple


  ```
  {:ok,
   %{card: %{address_city: "Hogwarts", address_country: "Straya",
       address_line1: "The Game Keepers Cottage", address_line2: nil,
       address_postcode: "H0G", address_state: "WA",
       customer_token: "cus_JVk_KByA5JiIsSPWVKt88Q",
       display_number: "XXXX-XXXX-XXXX-0000", expiry_month: 10, expiry_year: 2016,
       name: "Rubius Hagrid", primary: true, scheme: "visa",
       token: "card_EPh4cn4-fEMeZM_osPz1dg"}, created_at: "2015-11-15T08:40:50Z",
     email: "hagrid@hogwarts.wiz", token: "cus_JVk_KByA5JiIsSPWVKt88Q"}}
  ```
  OR

      {:error, error_map}
  """

  def get(id) do
    HTTPotion.get(customer_url <> "/#{id}", with_auth)
    |> handle_get
  end

  defp handle_get(%{status_code: 200, body: body}) do
    decoded = decode(body)
    {:ok, decoded.response}
  end

  defp handle_get(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp handle_get_all(%{status_code: 200, body: body}) do
    decoded = decode(body)
    mapped = %{pagination: decoded.pagination, customers: decoded.response}
    {:ok, mapped}
  end

  defp handle_get_all(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp customer_url do
    "https://#{@pin_url}/customers"
  end

  defp post_to_api(json) do
    HTTPotion.post(customer_url, with_auth([headers: ["Content-Type": "application/json"], body: json]))
  end


end
