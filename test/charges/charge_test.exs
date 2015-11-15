defmodule PinElixirTest.Charge do
  use ExUnit.Case
  use HyperMock

  import PinElixirTest.Utils

  alias PinElixirTest.Fixtures.Charge, as: ChargeFixture

  alias PinElixir.Charge

  test "Returns all current charges" do
    response = response ChargeFixture.all

    HyperMock.intercept_with get_all_request, response  do

      {:ok, charge_map} = Charge.get_all

      assert charge_map.pagination.count == 1
      assert hd(charge_map.charges).success == true
    end
  end

  test "Error response" do
    response = response ChargeFixture.get_all_fail, 400

    HyperMock.intercept_with get_all_request, response do

      {:error, body} = Charge.get_all

      #TODO Improve the canned response when I have internat access again
      assert body.error == "invalid_resource"
    end

  end

  test "Create with valid card" do
    response = response ChargeFixture.create_with_card_response, 201

    request = charge_request ChargeFixture.create_with_card_request

    HyperMock.intercept_with request, response do

      {:ok, charge_response} = Charge.create(%{charge: charge_map, card: card_map})

      assert charge_response.charge.success == true
      assert String.length(charge_response.charge.card[:token]) > 0
    end
  end

  test "Missing parameters" do
    response = response ChargeFixture.missing_parameters, 422

    HyperMock.intercept_with charge_request, response do

      {:error, error_response } = Charge.create(%{charge: charge_map, card: card_map})

      assert error_response.error == "invalid_resource"
      assert length(error_response.messages) == 1
    end
  end


  test "Card declined" do
    response = response ChargeFixture.card_declined, 400

    HyperMock.intercept_with charge_request, response do

      {:error, charge_response} = Charge.create(%{charge: charge_map, card: card_map})

      assert charge_response.error == "card_declined"
      assert charge_response.error_description == "The card was declined"
      assert charge_response.charge_token == "ch_lfUYEBK14zotCTykezJkfg"
    end
  end

  test "Insufficient funds" do
    response = response ChargeFixture.insufficient_funds, 400

    HyperMock.intercept_with charge_request, response do

      {:error, charge_response} = Charge.create(%{charge: charge_map, card: card_map})

      assert charge_response.error == "insufficient_funds"
      assert charge_response.error_description == "There are not enough funds available to process the requested amount"
      assert charge_response.charge_token == "ch_lfUYEBK14zotCTykezJkfg"
    end
  end

  test "create with customer token" do
    request = charge_request ChargeFixture.create_with_customer_token_request
    response = response ChargeFixture.create_with_card_response, 201

    HyperMock.intercept_with request, response  do

      {:ok, charge_response} = Charge.create(%{charge: charge_map, customer_token: "abcd123"})

      assert charge_response.charge.success == true
      #TODO Get proper response from customer token request when I have internet again

    end
  end

  test "create with card token" do
    response = response ChargeFixture.create_with_card_response, 201

    request = charge_request ChargeFixture.create_with_card_token_request

    HyperMock.intercept_with request, response do

      {:ok, card_token_response} = Charge.create(%{charge: charge_map, card_token: "card_123"})

      assert card_token_response.charge.success == true
    end
  end

  test "capture previously authorized charge" do
    response = response ChargeFixture.create_with_card_response, 201

    request = %HyperMock.Request{
      method: :put,
      uri: "https://test-api.pin.net.au/1/charges/abcd123/capture"
    }

    HyperMock.intercept_with request, response do

      {:ok, capture_response} = Charge.capture("abcd123")

      assert capture_response.charge.success == true
    end
  end

  test "get a charge" do
    response = response ChargeFixture.get

    HyperMock.intercept_with get_charge_request, response do

      {:ok, get_charge_response} = Charge.get("abcd123")

      assert get_charge_response.charge.amount == 400
    end
  end

  test "get a charge error" do
    response = response '{"error": "resource_not_found"}', 404

    HyperMock.intercept_with get_charge_request, response do

      {:error, get_charge_response} = Charge.get("abcd123")

      assert get_charge_response.error == "resource_not_found"
    end
  end

  def card_map do
    %{
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
  end

  defp charge_map do
    %{
      amount: 500,
      currency: "AUD",
      description: "Dragon Eggs",
      email: "hagrid@hogwarts.wiz",
      ip_address: "127.0.0.1"
    }
  end

  defp charge_request do
    %HyperMock.Request{
      body:   PinElixirTest.Fixtures.Charge.create_with_card_request,
      headers: ["Content-Type": "application/json"],
      method: :post,
      uri: "https://test-api.pin.net.au/1/charges"
    }
  end


  defp charge_request(body) do
    %HyperMock.Request{
      body: body,
      headers: ["Content-Type": "application/json"],
      method: :post,
      uri: "https://test-api.pin.net.au/1/charges"
    }
  end

  defp get_all_request do
    %HyperMock.Request{
      body: "",
      method: :get,
      uri: "https://test-api.pin.net.au/1/charges"
    }
  end

  defp get_charge_request do
    %HyperMock.Request{
      method: :get,
      uri: "https://test-api.pin.net.au/1/charges/abcd123"
    }
  end

end
