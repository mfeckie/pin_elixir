defmodule PinElixirTest.Customer do
  use ExUnit.Case
  use HyperMock

  alias PinElixir.Customer

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

  test "Create a customer with email and card" do
    HyperMock.intercept do
      request = %Request{
        body: PinElixirTest.Fixtures.Customer.create_request,
        method: :post,
        uri: "https://test-api.pin.net.au/1/customers"
      }
      response = %Response{
        body: PinElixirTest.Fixtures.Customer.create
      }

      stub_request request, response

      {:ok, customer_response} = Customer.create("foo@example.com", @card_map)

      assert customer_response.customer.email == "foo@example.com"

    end
  end

  test "Create customer failure" do
    HyperMock.intercept do
      request = %Request{
        body: PinElixirTest.Fixtures.Customer.create_error_request,
        method: :post,
        uri: "https://test-api.pin.net.au/1/customers"
      }
      response = %Response{
        body: PinElixirTest.Fixtures.Customer.create_error_response,
        status: 422
      }

      stub_request request, response

      {:error, customer_error_response} = Customer.create("", @card_map)

      assert customer_error_response.error == "invalid_resource"
    end
  end

end
