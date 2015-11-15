defmodule PinElixir.Balance do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response

  @pin_url Application.get_env(:pin_elixir, :pin_url)

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
