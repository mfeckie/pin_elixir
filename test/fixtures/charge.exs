defmodule PinElixirTest.Fixtures do
  defmodule Charge do
    def all do
      """
      {
        "response": [
          {
            "token": "ch_lfUYEBK14zotCTykezJkfg",
            "success": true,
            "amount": 400,
            "currency": "USD",
            "description": "test charge",
            "email": "roland@pin.net.au",
            "ip_address": "203.192.1.172",
            "created_at": "2012-06-20T03:10:49Z",
            "status_message": "Success",
            "error_message": null,
            "card": {
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
            },
            "captured": true,
            "authorisation_expired": false,
            "transfer": [
              {
                "state": "paid",
                "paid_at": "2012-06-27T03:10:49Z",
                "token": "tfer_j_u-Ef7aO0Y4CuLnGh92rg"
              }
            ],
            "amount_refunded": 0,
            "total_fees": 42,
            "merchant_entitlement": 358,
            "refund_pending": false,
            "settlement_currency": "AUD"
          }
        ],
        "pagination": {
          "current": 1,
          "per_page": 25,
          "count": 1
        }
      }
      """
    end

    def get_all_fail do
      '{"error":"invalid_resource","error_description":"One or more parameters were missing or invalid.","messages":[{"param":"amount","code":"amount_invalid","message":"Amount must be an integer"},{"param":"amount","code":"amount_invalid","message":"Amount must be more than 1 USD"}]}'
    end


    def create_with_card_response do
      '{"response":{"token":"ch_lfUYEBK14zotCTykezJkfg","success":true,"amount":400,"total_fees":10,"currency":"AUD","description":"test charge","email":"roland@pin.net.au","ip_address":"203.192.1.172","created_at":"2013-06-27T00:39:07Z","status_message":"Success","error_message":null,"card":{"token":"card_jxk5A8fjTtmz6Y81NX9G7w","display_number":"XXXX-XXXX-XXXX-0000","scheme":"master","address_line1":"42 Sevenoaks St","address_line2":null,"address_city":"Lathlain","address_postcode":"6454","address_state":"WA","address_country":"Australia"},"transfer":null}}'
    end

    def create_with_card_request do
      "{\"ip_address\":\"127.0.0.1\",\"email\":\"hagrid@hogwarts.wiz\",\"description\":\"Dragon Eggs\",\"currency\":\"AUD\",\"card\":{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":\"H0G\",\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"},\"amount\":500}"
    end

    def card_declined do
    """
    {
      "error": "card_declined",
      "error_description": "The card was declined",
      "charge_token": "ch_lfUYEBK14zotCTykezJkfg"
    }
    """
    end

    def insufficient_funds do
    """
    {
      "error": "insufficient_funds",
      "error_description": "There are not enough funds available to process the requested amount",
      "charge_token": "ch_lfUYEBK14zotCTykezJkfg"
    }
    """
    end

    def missing_parameters do
    """
    {
      "error": "invalid_resource",
      "error_description": "One or more parameters were missing or invalid.",
      "messages": [
        {
          "code": "description_invalid",
          "message": "Description can't be blank",
          "param": "description"
        }
      ]
    }
    """
    end

    def create_with_customer_token_request do
      "{\"ip_address\":\"127.0.0.1\",\"email\":\"hagrid@hogwarts.wiz\",\"description\":\"Dragon Eggs\",\"customer_token\":\"abcd123\",\"currency\":\"AUD\",\"amount\":500}"
    end

    def create_with_card_token_request do
      "{\"ip_address\":\"127.0.0.1\",\"email\":\"hagrid@hogwarts.wiz\",\"description\":\"Dragon Eggs\",\"currency\":\"AUD\",\"card_token\":\"card_123\",\"amount\":500}"
    end

    def get do
      """
      {
        "response": {
          "token": "ch_lfUYEBK14zotCTykezJkfg",
          "success": true,
          "amount": 400,
          "currency": "USD",
          "description": "test charge",
          "email": "roland@pin.net.au",
          "ip_address": "203.192.1.172",
          "created_at": "2012-06-20T03:10:49Z",
          "status_message": "Success",
          "error_message": null,
          "card": {
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
          },
          "captured": true,
          "authorisation_expired": false,
          "transfer": [
            {
              "state": "paid",
              "paid_at": "2012-06-27T03:10:49Z",
              "token": "tfer_j_u-Ef7aO0Y4CuLnGh92rg"
            }
          ],
          "amount_refunded": 0,
          "total_fees": 42,
          "merchant_entitlement": 358,
          "refund_pending": false,
          "settlement_currency": "AUD"
        }
      }
      """
    end
  end
end
