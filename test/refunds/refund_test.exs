defmodule PinElixirTest.Refund do
  use ExUnit.Case
  use HyperMock

  import PinElixirTest.Utils

  alias PinElixirTest.Fixtures.Refund, as: RefundFixture

  alias PinElixir.Refund

  test "Successfully requests a refund" do
    response = response RefundFixture.refund_success_response, 201
    request = refund_request

    HyperMock.intercept_with request, response do
      {:ok, refund_response } = Refund.request("abc_123")

      assert refund_response.status_message == "Pending"
    end

  end

  test "Successfully requests a partial refund" do
    response = response RefundFixture.partial_refund_success_response, 201
    request = refund_request("{\"amount\":200}")

    HyperMock.intercept_with request, response do
      {:ok, refund_response } = Refund.request("abc_123", 200)

      assert refund_response.status_message == "Pending"
      assert refund_response.amount == 200
    end

  end

  test "Refund request failure" do
    response = response RefundFixture.refund_failure_response, 422
    request = refund_request

    HyperMock.intercept_with request, response do
      {:error, error_response } = Refund.request("abc_123")

      assert error_response.error  == "insufficient_pin_balance"
    end

  end

  test "retreives all refunds" do
    request = get_all_request
    response = response RefundFixture.get_all_response

    HyperMock.intercept_with request, response do
      {:ok, refund_response} = Refund.get

      assert length(refund_response.refunds) == 1
    end
  end

  test "Get all refunds failure" do
    request = get_all_request
    response = response '{"error": "bad stuff"}', 400

    HyperMock.intercept_with request, response do
      assert {:error, %{error: "bad stuff"}} == Refund.get
    end
  end

  test "retreives refunds for a specific charge" do
    request = get_refunds_request
    response = response RefundFixture.get_refunds_response

    HyperMock.intercept_with request, response do
      {:ok, refund_response} = Refund.get("abc_123")

      assert length(refund_response.refunds) == 1
    end
  end

  defp get_refunds_request do
    %HyperMock.Request{
      body: "",
      method: :get,
      uri: "https://test-api.pin.net.au/1/charges/abc_123/refunds"
    }
  end


  defp get_all_request do
    %HyperMock.Request{
      body: "",
      method: :get,
      uri: "https://test-api.pin.net.au/1/refunds"
    }
  end

  defp refund_request(body \\ "") do
    %HyperMock.Request{
      body: body,
      method: :post,
      headers: ["Content-Type": "application/json"],
      uri: "https://test-api.pin.net.au/1/charges/abc_123/refunds"
    }
  end
end
