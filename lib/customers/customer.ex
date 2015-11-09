defmodule PinElixir.Customer do

  @pin_url Application.get_env :pin_elixir, :pin_url
  @api_key Application.get_env(:pin_elixir, :api_key)
  @auth basic_auth: {@api_key, ""}

  def create(email, %{card: card}) do
    json = Poison.encode!(%{email: email, card: card})

    HTTPotion.post(customer_url, [@auth, headers: ["Content-Type": "application/json"], body: json])
    |> handle_create_customer_response
  end

  def create(email, %{card_token: card_token}) do
    json = Poison.encode!(%{email: email, card_token: card_token})

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

  def delete(token) do
    HTTPotion.delete(customer_url <> "/#{token}")
    |> handle_delete
  end

  defp handle_delete(%{status_code: 200}) do
    {:ok, %{}}
  end

  defp handle_delete(%{status_code: 422, body: body}) do
    message = Poison.decode!(body, keys: :atoms )
    {:error, message}
  end

  defp customer_url do
    "https://#{@pin_url}/customers"
  end

end
