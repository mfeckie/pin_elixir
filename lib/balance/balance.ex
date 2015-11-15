defmodule PinElixir.Balance do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response

  @moduledoc """
  Allows querying of pin account balance
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)

  @doc """
  Provides a representation of the current pin account balance and pending transactions

  returns a tuple

  ```
  {:ok,
    %{balance:
      %{
        available: [%{amount: 50000, currency: "AUD"}],
        pending: [%{amount: 50000, currency: "AUD"}]
      }
    }
  }
  ```

  OR
      {:error, error_map}
  """

  def get do
    HTTPotion.get("https://#{@pin_url}/balance", with_auth)
    |> handle_get
  end

  defp handle_get(%{status_code: 200, body: body}) do
    decoded = body |> decode
    {:ok, %{balance: decoded.response}}
  end

  defp handle_get(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

end
