defmodule PinElixir.Charge do
  require Logger

  defstruct [:amount, :currency, :description, :email, :ip_address, :card, :success]

  @moduledoc """
  Handles the creation and retrieval of charges
  """

  @pin_url PinElixir.Support.get_config(:pin_url)
  @api_key PinElixir.Support.get_config(:api_key)
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
                   as: %{"response" => [PinElixir.Charge],
                         pagination: PinElixir.Pagination},
                   keys: :atoms)
    |> rename_response_field
    |> wrap_in_tuple
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

  defp wrap_in_tuple(map) do
    {:ok, map}
  end

  def create(charge_map) do
    json = Poison.encode!(charge_map)

    response = HTTPotion.post(charges_url, [@auth, headers: ["Content-Type": "application/json"], body: json ])
    Poison.decode!(response.body,
                   as: %{"response" => PinElixir.Charge},
                   keys: :atoms)
    |> Map.fetch! :response
  end

  defp charges_url do
    "https://#{@pin_url}/charges"
  end

end
