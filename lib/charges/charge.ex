defmodule PinElixir.Charge do
  require Logger
  import PinElixir.Utils.RequestOptions

  alias PinElixir.Pagination

  @derive [Poison.Encoder]

  defstruct [:amount, :currency, :description, :email, :ip_address, :card, :success]

  @moduledoc """
    Handles the creation and retrieval of charges
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)


  @doc """
    Retreives all charges

    Returns a tuple
    ```
    {:ok, charge_map}
    or
    {:error, error_map}
    ```
  """
  def get_all do
    HTTPotion.get(charges_url, with_auth)
    |> handle_get_all
  end

  defp handle_get_all(%{status_code: 200, body: body}) do
    Logger.debug fn -> inspect(body) end
    Poison.decode!(body,
                   as: %{"response" => [Charge],
                         pagination: Pagination},
                   keys: :atoms)
    |> rename_response_field
    |> wrap_in_success_tuple
  end

  defp handle_get_all(%{status_code: ___, body: body}) do
    Logger.debug fn -> inspect(body) end
    {:error, Poison.decode!(body)}
  end

  defp rename_response_field(response) do
    %{charges: response.response,
      pagination: response.pagination}
  end

  defp wrap_in_success_tuple(map) do
    {:ok, map}
  end

  @doc """
    Given a charge token returns a tuple

    ```
    {:ok, charge_map}
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
    decoded = Poison.decode!(body, keys: :atoms)
    {:ok, %{charge: decoded.response}}
  end

  defp handle_get(%{status_code: 404, body: body}) do
    decoded = Poison.decode!(body, keys: :atoms)
    {:error, decoded}
  end

  @doc """
    Takes a map representing a customer charge

    Can be used with a card, customer_token or card_token key
    ```
    %{
      amount: 500,
      currency: "AUD", // Optional (default: "AUD")
      description: "Dragon Eggs",
      email: "hagrid@hogwarts.wiz",
      ip_address: "127.0.0.1",
        card: %{  // Optional
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
      card_token: "abcd123" // Optional
      customer_token: "cust_123" // Optional
      capture: false // Optional (default: true)
    }
    ```

    returns a tuple representing the outcome of the charge

    `{:ok, charge_response}`
    OR
    `{:error, error_message}`
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

  defp handle_charge_response(%{status_code: 200, body: body}) do
    Poison.decode!(body,
                   as: %{"response" => Charge},
                   keys: :atoms)
    |> rename_charge_field
    |> wrap_in_success_tuple
  end

  defp handle_charge_response(%{status_code: 422, body: body}) do
    #TODO Improve response from this function, maybe parse errors?
    {:error, Poison.decode!(body, keys: :atoms)}
  end

  defp handle_charge_response(%{status_code: 400, body: body}) do
    {:error, Poison.decode!(body, keys: :atoms)}
  end

  defp rename_charge_field(map) do
    %{charge: map.response}
  end

  def capture(token) do
    HTTPotion.put(charges_url <> "/#{token}/capture", with_auth)
    |> handle_charge_response
  end

  defp charges_url do
    "https://#{@pin_url}/charges"
  end



end
