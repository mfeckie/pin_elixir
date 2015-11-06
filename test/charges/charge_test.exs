defmodule PinElixirTest.Charge do
  use ExUnit.Case
  use HyperMock
  alias PinElixir.Charge

  @card_map %{
    number: 4200000000000000,
    expiry_month: "10",
    expiry_year: 2016,
    cvc: 456,
    name: "Rubius Hagrid",
    address_line1: "The Game Keepers Cottage",
    address_city: "Hogwarts",
    address_postcode: "H0G",
    address_state: "WA",
    address_country: "Straya"
  }

  @charge_map %{
    amount: 500,
    currency: "AUD",
    description: "Dragon Eggs",
    email: "hagrid@hogwarts.wiz",
    ip_address: "127.0.0.1"
  }

  defp charge_request do
    %HyperMock.Request{
      body: PinElixirTest.Fixtures.Charge.create_with_card_request,
      headers: ["Content-Type": "application/json"],
      method: :post,
      uri: "https://test-api.pin.net.au/1/charges"
    }
  end

  test "Returns all current charges" do
    HyperMock.intercept do
      request = %Request{
        body: "",
        method: :get,
        uri: "https://test-api.pin.net.au/1/charges"
      }
      response = %Response{body: PinElixirTest.Fixtures.Charge.all }

      stub_request(request, response)

      {:ok, charge_map} = Charge.get_all

      assert charge_map.pagination.count == 1
      assert hd(charge_map.charges).success == true
    end
  end

  test "Error response" do
    HyperMock.intercept do
      request = %Request{
        body: "",
        method: :get,
        uri: "https://test-api.pin.net.au/1/charges"
      }
      response = %Response{body: PinElixirTest.Fixtures.Charge.get_all_fail, status: 400}

      stub_request request, response

      {:error, body} = Charge.get_all

      #TODO Improve the canned response when I have internat access again
      assert body["error"] == "invalid_resource"
    end

  end

  test "Create with valid card" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.create_with_card_response}

      stub_request charge_request, response

      {:ok, charge_response} = Charge.create(%{charge: @charge_map, card: @card_map})

      assert charge_response.charge.success == true
      assert String.length(charge_response.charge.card[:token]) > 0
    end
  end

  test "Missing parameters" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.missing_parameters, status: 422}
      stub_request charge_request, response

      {:error, error_response } = Charge.create(%{charge: @charge_map, card: @card_map})

      assert error_response.error == "invalid_resource"
      assert length(error_response.messages) == 1
    end
  end


  test "Card declined" do
    HyperMock.intercept do
      response = %Response{status: 400, body: PinElixirTest.Fixtures.Charge.card_declined}

      stub_request charge_request, response

      {:error, charge_response} = Charge.create(%{charge: @charge_map, card: @card_map})

      assert charge_response.error == "card_declined"
      assert charge_response.error_description == "The card was declined"
      assert charge_response.charge_token == "ch_lfUYEBK14zotCTykezJkfg"
    end
  end

  test "Insufficient funds" do
    HyperMock.intercept do
      response = %Response{status: 400, body: PinElixirTest.Fixtures.Charge.insufficient_funds}

      stub_request charge_request, response

      {:error, charge_response} = Charge.create(%{charge: @charge_map, card: @card_map})

      assert charge_response.error == "insufficient_funds"
      assert charge_response.error_description == "There are not enough funds available to process the requested amount"
      assert charge_response.charge_token == "ch_lfUYEBK14zotCTykezJkfg"
    end
  end

  test "create with customer token" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.create_with_card_response}

      request =    %HyperMock.Request{
        body: PinElixirTest.Fixtures.Charge.create_with_customer_token_request,
        headers: ["Content-Type": "application/json"],
        method: :post,
        uri: "https://test-api.pin.net.au/1/charges"
      }

      stub_request request, response

      {:ok, charge_response} = Charge.create(%{charge: @charge_map, customer_token: "abcd123"})

      assert charge_response.charge.success == true
      #TODO Get proper response from customer token request when I have internet again

    end
  end

  test "create with card token" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.create_with_card_response}
      request =    %HyperMock.Request{
        body: PinElixirTest.Fixtures.Charge.create_with_card_token_request,
        headers: ["Content-Type": "application/json"],
        method: :post,
        uri: "https://test-api.pin.net.au/1/charges"
      }

      stub_request request, response

      {:ok, card_token_response} = Charge.create(%{charge: @charge_map, card_token: "card_123"})

      assert card_token_response.charge.success == true
    end
  end

  test "capture previously authorized charge" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.create_with_card_response}
      request =    %HyperMock.Request{
        method: :put,
        uri: "https://test-api.pin.net.au/1/charges/abcd123/capture"
      }

      stub_request request, response

      {:ok, capture_response} = Charge.capture("abcd123")

      assert capture_response.charge.success == true
    end
  end

  test "get a charge" do
    HyperMock.intercept do
      response = %Response{body: PinElixirTest.Fixtures.Charge.get}
      request = %HyperMock.Request{
        method: :get,
        uri: "https://test-api.pin.net.au/1/charges/abcd123"
      }

      stub_request request, response

      {:ok, get_charge_response} = Charge.get("abcd123")

      assert get_charge_response.charge.amount == 400
    end
  end

  test "get a charge error" do
    HyperMock.intercept do
      response = %Response{body: '{"error": "resource_not_found"}', status: 404}
      request = %HyperMock.Request{
        method: :get,
        uri: "https://test-api.pin.net.au/1/charges/abcd123"
      }

      stub_request request, response

      {:error, get_charge_response} = Charge.get("abcd123")

      assert get_charge_response.error == "resource_not_found"
    end
  end

end
