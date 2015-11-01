defmodule PinElixirTest.Charge do
  use ExUnit.Case
  use HyperMock
  alias PinElixir.Charge

  @card_map  %{
    number: 4200000000000000,
    expiry_month: "10",
    expiry_year: 2016,
    cvc: 456,
    name: "Rubius Hagrid",
    address_line1: "The Game Keepers Cottage",
    address_city: "Hogwarts",
    address_postcode: 6000,
    address_state: "WA",
    address_country: "Straya"
  }

  @charge_map %{
    amount: 500,
    currency: "AUD",
    description: "Dragon Eggs",
    email: "hagrid@hogwarts.wiz",
    ip_address: "127.0.0.1",
    card: @card_map
  }

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

      assert charge_map.count == 2
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
      request = %Request{
        body: PinElixirTest.Fixtures.Charge.create_with_card_request,
        headers: ["Content-Type": "application/json"],
        method: :post,
        uri: "https://test-api.pin.net.au/1/charges"
      }
      response = %Response{body: PinElixirTest.Fixtures.Charge.create_with_card_response}

      stub_request request, response

      charge_response = Charge.create(@charge_map)

      assert charge_response.success == true
      assert String.length(charge_response.card[:token]) > 0
    end
  end
end
