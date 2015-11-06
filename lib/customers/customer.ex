defmodule PinElixir.Customer do

  @pin_url Application.get_env :pin_elixir, :pin_url
  @api_key Application.get_env(:pin_elixir, :api_key)
  @auth basic_auth: {@api_key, ""}

  def create(email, card) do
    json = Poison.encode!(%{email: email, card: card})

    HTTPotion.post(customer_url, [@auth, headers: ["Content-Type": "application/json"], body: json])
    |> handle_create_customer_response
  end

  defp handle_create_customer_response(%{status_code: 200, body: body}) do
    decoded = Poison.decode!(body, keys: :atoms)
    {:ok, %{customer: decoded.response}}
  end

  defp handle_create_customer_response(%{status_code: 422, body: body}) do
    decoded = Poison.decode!(body, keys: :atoms)
    {:error, decoded}
  end

  defp customer_url do
    "https://#{@pin_url}/customers"
  end

end
