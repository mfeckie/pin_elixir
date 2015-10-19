defmodule PinElixirTest.Charge do
  use ExUnit.Case
  use HyperMock
  alias PinElixir.Charges

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

  @charge_create "{\"ip_address\":\"127.0.0.1\",\"email\":\"hagrid@hogwarts.wiz\",\"description\":\"Dragon Eggs\",\"currency\":\"AUD\",\"card\":{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":6000,\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"},\"amount\":500}"

  @charge_success_response '{"response":{"token":"ch_6haTbpNEhAL4BIFqZJ4lxQ","success":true,"amount":500,"currency":"AUD","description":"Dragon Eggs","email":"hagrid@hogwarts.wiz","ip_address":"127.0.0.1","created_at":"2015-10-19T01:52:37Z","status_message":"Success","error_message":null,"card":{"token":"card_1urjWEWa6vGdgQSVWyk6ZQ","scheme":"visa","display_number":"XXXX-XXXX-XXXX-0000","expiry_month":12,"expiry_year":2016,"name":"Rubius Hagrid","address_line1":"The Game Keepers Cottage","address_line2":null,"address_city":"Hogwarts","address_postcode":6000,"address_state":"WA","address_country":"Straya","customer_token":null,"primary":null},"transfer":[],"amount_refunded":0,"total_fees":45,"merchant_entitlement":455,"refund_pending":false,"authorisation_expired":false,"captured":true,"settlement_currency":"AUD"}}'

  test "Returns all current charges" do
    HyperMock.intercept do
      request = %Request{body: "", headers: [], method: :get, uri: "https://test-api.pin.net.au/1/charges"}
      response = %Response{body: Poison.encode!(%{count: 0}) }

      stub_request(request, response)

      charges_response = Charges.get_all

      json = charges_response.body |> Poison.decode!
      assert json["count"] == 0
    end
  end

  test "Makes a charge request" do
    HyperMock.intercept do
      request = %Request{body: @charge_create, headers: ["Content-Type": "application/json"], method: :post, uri: "https://test-api.pin.net.au/1/charges"}
      response = %Response{body: @charge_success_response}

      stub_request request, response
      charge_response = Charges.create(@charge_map)
      success_response = Poison.decode!(charge_response.body)["response"]["success"]
      assert success_response == true
    end
  end
end
