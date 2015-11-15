defmodule PinElixirTest.Fixtures.Card do
  def create do
    """
    {
      "response": {
        "token": "card_pIQJKMs93GsCc9vLSLevbw",
        "scheme": "master",
        "display_number": "XXXX-XXXX-XXXX-0000",
        "expiry_month": 6,
        "expiry_year": 2020,
        "name": "Roland Robot",
        "address_line1": "42 Sevenoaks St",
        "address_line2": null,
        "address_city": "Lathlain",
        "address_postcode": "6454",
        "address_state": "WA",
        "address_country": "Australia",
        "primary": null
      }
    }
    """
  end

  def create_request do
    "{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":\"H0G\",\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"}"
  end

  def error do
    """
    {
      "error": "invalid_resource",
      "error_description": "One or more parameters were missing or invalid.",
      "messages": [
        {
          "code": "number_invalid",
          "message": "Number can't be blank",
          "param": "number"
        }
      ]
    }
    """
  end


end
