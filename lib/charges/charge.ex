defmodule PinElixir.Charge do
  require Logger
  alias PinElixir.Pagination
  @derive [Poison.Encoder]

  defstruct [:amount, :currency, :description, :email, :ip_address, :card, :success]

  @moduledoc """
  Handles the creation and retrieval of charges
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)
  @api_key Application.get_env(:pin_elixir, :api_key)
  @auth basic_auth: {@api_key, ""}

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
    HTTPotion.get(charges_url, [@auth])
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
    %{count: response.count,
      charges: response.response,
      pagination: response.pagination}
  end

  defp wrap_in_success_tuple(map) do
    {:ok, map}
  end
  @doc """
  Takes a map representing a customer charge
  in the form
  %{
    amount: 500,
    currency: "AUD",
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


  """
  def create_with_card(charge_map) do
    json = Poison.encode!(charge_map)

    HTTPotion.post(charges_url, [@auth, headers: ["Content-Type": "application/json"], body: json ])
    |> handle_charge_create

  end

  defp handle_charge_create(%{status_code: 200, body: body}) do
    Poison.decode!(body,
                   as: %{"response" => Charge},
                   keys: :atoms)
    |> rename_charge_field
    |> wrap_in_success_tuple
  end

  defp handle_charge_create(%{status_code: 422, body: body}) do
    #TODO Improve response from this function, maybe parse errors?
    {:error, Poison.decode!(body, keys: :atoms)}
  end

  defp handle_charge_create(%{status_code: 400, body: body}) do
    {:error, Poison.decode!(body, keys: :atoms)}
  end

  defp rename_charge_field(map) do
    %{charge: map.response}
  end

  defp charges_url do
    "https://#{@pin_url}/charges"
  end

end
