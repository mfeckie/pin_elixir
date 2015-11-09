defmodule PinElixir.Customer do

  @pin_url Application.get_env :pin_elixir, :pin_url
  @api_key Application.get_env(:pin_elixir, :api_key)
  @auth basic_auth: {@api_key, ""}

  def create(email, %{card: card}) do
    json = Poison.encode!(%{email: email, card: card})

    post(json)
    |> handle_create_customer_response
  end

  def create(email, %{card_token: card_token}) do
    json = Poison.encode!(%{email: email, card_token: card_token})

    post(json)
    |> handle_create_customer_response
  end

  defp handle_create_customer_response(%{status_code: 200, body: body}) do
    decoded = decode(body)
    {:ok, %{customer: decoded.response}}
  end

  defp handle_create_customer_response(%{status_code: 422, body: body}) do
    decode(body)
    |> to_error_tuple
  end

  def delete(token) do
    HTTPotion.delete(customer_url <> "/#{token}")
    |> handle_delete
  end

  defp handle_delete(%{status_code: 200}) do
    {:ok, %{}}
  end

  defp handle_delete(%{status_code: 422, body: body}) do
    decode(body)
    |> to_error_tuple
  end

  def get do
    HTTPotion.get(customer_url, [@auth])
    |> handle_get_all
  end

  defp handle_get_all(%{status_code: 200, body: body}) do
    decoded = decode(body)
    mapped = %{pagination: decoded.pagination, customers: decoded.response}
    {:ok, mapped}
  end

  defp handle_get_all(%{status_code: ___, body: body}) do
    decode(body)
    |> to_error_tuple
  end

  defp customer_url do
    "https://#{@pin_url}/customers"
  end

  defp decode(body) do
    Poison.decode!(body, keys: :atoms)
  end

  defp to_error_tuple(body) do
    {:error, body}
  end

  defp post(json) do
    HTTPotion.post(customer_url, [@auth, headers: ["Content-Type": "application/json"], body: json])
  end


end
