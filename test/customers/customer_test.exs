defmodule PinElixirTest.Customer do
  use ExUnit.Case
  use HyperMock

  alias PinElixir.Customer
  alias PinElixirTest.Fixtures.Customer, as: CustomerFixture

  test "Create a customer with email and card" do
    request = create_request CustomerFixture.create_with_email_request

    HyperMock.intercept_with request, response do

      {:ok, customer_response} = Customer.create("foo@example.com", %{card: card_map })

      assert customer_response.customer.email == "foo@example.com"

    end
  end

  test "Create a customer with email and card_token" do
    request = create_request CustomerFixture.create_with_card_token_request

    HyperMock.intercept_with request, response do

      {:ok, customer_response} = Customer.create("foo@example.com", %{card_token: "abc_a123" })

      assert customer_response.customer.email == "foo@example.com"

    end
  end

  test "Create customer failure" do
    request = create_request CustomerFixture.create_error_request

    response = response CustomerFixture.create_error_response, 422

    HyperMock.intercept_with request, response do

      {:error, customer_error_response} = Customer.create("", %{card: card_map})
      assert customer_error_response.error == "invalid_resource"
    end
  end

  test "delete a customer" do
    request = %HyperMock.Request{
      method: :delete,
      uri: "https://test-api.pin.net.au/1/customers/abc123"
    }
    response = response '{"response":{}}'

    HyperMock.intercept_with request, response do

      {:ok, result} = Customer.delete("abc123")

      assert result == %{}
    end
  end

  test "delete a customer failure" do
    request = %HyperMock.Request{
      method: :delete,
      uri: "https://test-api.pin.net.au/1/customers/abc123"
    }

    response = response '{"error":"resource_not_found","error_description":"No resource was found at this URL."}', 422

    HyperMock.intercept_with request, response do

      {:error, error_message} = Customer.delete("abc123")

      assert error_message.error == "resource_not_found"
    end
  end

  test "Getting all customers" do
      request = %HyperMock.Request{
        method: :get,
        uri: "https://test-api.pin.net.au/1/customers"
      }
      response = response CustomerFixture.get_all_customers

     HyperMock.intercept_with request, response do

      {:ok, customers_response} = Customer.get

      assert length(customers_response.customers) == 1
    end
  end

  test "Get all customers failure" do
    request = %HyperMock.Request{
      method: :get,
      uri: "https://test-api.pin.net.au/1/customers"
    }

    response = response CustomerFixture.get_all_customers_error, 422

    HyperMock.intercept_with request, response do

      {:error, error_response} = Customer.get

      assert error_response.error == "some error"
    end
  end

  test "Getting a customer" do
    request = %HyperMock.Request{
      method: :get,
      uri: "https://test-api.pin.net.au/1/customers/abc_123"
    }

    response = response CustomerFixture.get_customer

    HyperMock.intercept_with request, response  do

      {:ok, customer} = Customer.get("abc_123")

      assert customer.email == "roland@pin.net.au"
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

  defp create_request(body) do
    %HyperMock.Request{
      body: body,
      method: :post,
      headers: ["Content-Type": "application/json"],
      uri: "https://test-api.pin.net.au/1/customers"
    }

  end

  defp response(body \\ CustomerFixture.create_success , status \\ 200) do
    %HyperMock.Response{
      body: body,
      status: status
    }
  end

end
