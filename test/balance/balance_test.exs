defmodule PinElixirTest.Balance do
  use ExUnit.Case

  use HyperMock

  import PinElixirTest.Utils

  alias PinElixir.Balance
  alias PinElixirTest.Fixtures.Balance, as: BalanceFixture

  test "Gets balance" do
    request = %HyperMock.Request{
      method: :get,
      uri: "https://test-api.pin.net.au/1/balance"
    }
    response = response BalanceFixture.get_response

    HyperMock.intercept_with request, response do
      {:ok, balance_response} = Balance.get
      assert balance_response.balance.available == [%{amount: 400, currency: "AUD"}]
    end
  end

end
