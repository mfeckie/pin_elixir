defmodule PinElixir.Refund do
  import PinElixir.Utils.RequestOptions
  import PinElixir.Utils.Response

  @moduledoc """
  Responsible for refunding of charges and retreiving refund details
  """

  @pin_url Application.get_env(:pin_elixir, :pin_url)

  @doc """
  Requests a full refund given a charge_token

  Returns a tuple

  ```
  {:ok,
   %{amount: 500, charge: "ch_NCoA7oBzrycXEPBTEUWNdQ",
     created_at: "2015-11-15T08:49:46Z", currency: "AUD", error_message: nil,
     status_message: "Pending", success: nil, token: "rf_HWV4-cB6UNlh_Tdc5ZaC8g"}}
  ```

  OR

      {:error, error_map}
  """

  def request(charge_token) do
    HTTPotion.post("#{charge_refund_url}/#{charge_token}/refunds", with_auth(headers: ["Content-Type": "application/json"]))
    |> handle_refund_request_response
  end

  @doc """
  Requests a partial refund given a charge_token

  Returns a tuple

  ```
  {:ok,
   %{amount: 100, charge: "ch_lENRObt9AvXvuUszuq5FBA",
     created_at: "2015-11-15T08:50:55Z", currency: "AUD", error_message: nil,
     status_message: "Pending", success: nil, token: "rf_djFwf03PLpp4G7cGEr_5mg"}}
   ```

  OR

      {:error, error_map}
  """

  def request(charge_token, partial_amount) do
    json = Poison.encode!(%{amount: partial_amount})

    HTTPotion.post("#{charge_refund_url}/#{charge_token}/refunds", with_auth(headers: ["Content-Type": "application/json"],body: json))
    |> handle_refund_request_response
  end


  defp handle_refund_request_response(%{status_code: 201, body: body}) do
    decoded =  decode(body).response
    {:ok, decoded}
  end

  defp handle_refund_request_response(%{status_code: 422, body: body}) do
    body
    |> to_error_tuple
  end

  @doc """
  Retreives all refunds

  Returns a tuple


  ```
  {:ok,
   %{pagination: %{count: 9, current: 1, next: nil, pages: 1, per_page: 25,
       previous: nil},
     refunds: [%{amount: 100, charge: "ch_lENRObt9AvXvuUszuq5FBA",
        created_at: "2015-11-15T08:50:55Z", currency: "AUD", error_message: nil,
        status_message: "Pending", success: nil,
        token: "rf_djFwf03PLpp4G7cGEr_5mg"},
      %{amount: 500, charge: "ch_NCoA7oBzrycXEPBTEUWNdQ",
        created_at: "2015-11-15T08:49:46Z", currency: "AUD", error_message: nil,
        status_message: "Pending", success: nil,
        token: "rf_HWV4-cB6UNlh_Tdc5ZaC8g"}]
      }
    }
  ```

  OR

      {:error, error_map}
  """

  def get do
    HTTPotion.get(refund_url, with_auth)
    |> handle_get
  end

  @doc """
  Given a charge token, retreives associated refund(s)

  Returns a tuple

  ```
  {:ok,
   %{pagination: %{count: 1, current: 1, next: nil, pages: 1, per_page: 25,
       previous: nil},
     refunds: [%{amount: 100, charge: "ch_lENRObt9AvXvuUszuq5FBA",
        created_at: "2015-11-15T08:50:55Z", currency: "AUD", error_message: nil,
        status_message: "Pending", success: nil,
        token: "rf_djFwf03PLpp4G7cGEr_5mg"}]}}
  ```

  OR

      {:error, error_map}
  """

  def get(charge_token) do
    HTTPotion.get(charge_refund_url <> "/#{charge_token}/refunds", with_auth)
    |> handle_get
  end


  defp handle_get(%{status_code: 200, body: body}) do
    decoded = decode(body)
    {:ok, %{refunds: decoded.response, pagination: decoded.pagination}}
  end

  defp handle_get(%{status_code: ___, body: body}) do
    body |> to_error_tuple
  end

  defp refund_url do
    "https://#{@pin_url}/refunds"
  end

  defp charge_refund_url do
    "https://#{@pin_url}/charges"
  end

end
