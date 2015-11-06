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
        headers: ["Content-Type": "application/json"],
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
        headers: ["Content-Type": "application/json"],
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

  test "delete a customer" do
    HyperMock.intercept do
      request = %Request{
        method: :delete,
        uri: "https://test-api.pin.net.au/1/customers/abc123"
      }
      response = %Response{
        body: '{"response":{}}'
      }

      stub_request request, response

      {:ok, result} = Customer.delete("abc123")

      assert result == %{}
    end
  end

  test "delete a customer failure" do
    HyperMock.intercept do
      request = %Request{
        method: :delete,
        uri: "https://test-api.pin.net.au/1/customers/abc123"
      }
      response = %Response{
        status: 422,
        body: '{"error":"resource_not_found","error_description":"No resource was found at this URL."}'
      }

      stub_request request, response

      {:error, error_message} = Customer.delete("abc123")

      assert error_message.error == "resource_not_found"
    end
  end
end
