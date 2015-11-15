defmodule PinElixirTest.Card do
  use ExUnit.Case
  use HyperMock

  alias PinElixir.Card
  alias PinElixirTest.Fixtures.Card, as: CardFixture

  import PinElixirTest.Utils

  test "Creates a card token from a credit card" do
    request = %HyperMock.Request{
      headers: ["Content-Type": "application/json"],
      method: :post,
      uri: "https://test-api.pin.net.au/1/cards",
      body: CardFixture.create_request
    }
    response = response CardFixture.create, 201
    HyperMock.intercept_with request, response do
      {:ok, card_create_response} = Card.create(card_map)

      assert card_create_response.card.token == "card_pIQJKMs93GsCc9vLSLevbw"
    end
  end

  test "Create card failure" do
    request = %HyperMock.Request{
      headers: ["Content-Type": "application/json"],
      method: :post,
      uri: "https://test-api.pin.net.au/1/cards",
      body: CardFixture.create_request
    }
    response = response CardFixture.error, 422
    HyperMock.intercept_with request, response do
      {:error, card_create_response} = Card.create(card_map)

      assert card_create_response.error == "invalid_resource"
    end
  end

end
