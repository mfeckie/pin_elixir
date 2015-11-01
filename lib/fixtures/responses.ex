defmodule PinElixirTest.Fixtures do
  defmodule Charge do
    def all do
      '{"response":[{"token":"ch_lfUYEBK14zotCTykezJkfg","success":true,"amount":400,"total_fees":10,"currency":"AUD","description":"test charge","email":"roland@pin.net.au","ip_address":"203.192.1.172","created_at":"2013-06-27T00:39:07Z","status_message":"Success","error_message":null,"card":{"token":"card_nytGw7koRg23EEp9NTmz9w","display_number":"XXXX-XXXX-XXXX-0000","scheme":"master","address_line1":"42 Sevenoaks St","address_line2":null,"address_city":"Lathlain","address_postcode":"6454","address_state":"WA","address_country":"Australia"},"transfer":null},{"token":"ch_shldvbE5eqBQuyY9Fryhzw","success":true,"amount":400,"currency":"AUD","description":"test charge","email":"roland@pin.net.au","ip_address":"203.192.1.172","created_at":"2013-06-27T00:38:41Z","status_message":"Success","error_message":null,"card":{"token":"card_nytGw7koRg23EEp9NTmz9w","display_number":"XXXX-XXXX-XXXX-0000","scheme":"master","address_line1":"42 Sevenoaks St","address_line2":null,"address_city":"Lathlain","address_postcode":"6454","address_state":"WA","address_country":"Australia"},"transfer":null}],"count":2,"pagination":{"current":1,"previous":null,"next":1,"per_page":25,"pages":1,"count":2}}'
    end

    def create_with_card_response do
      '{"response":{"token":"ch_lfUYEBK14zotCTykezJkfg","success":true,"amount":400,"total_fees":10,"currency":"AUD","description":"test charge","email":"roland@pin.net.au","ip_address":"203.192.1.172","created_at":"2013-06-27T00:39:07Z","status_message":"Success","error_message":null,"card":{"token":"card_jxk5A8fjTtmz6Y81NX9G7w","display_number":"XXXX-XXXX-XXXX-0000","scheme":"master","address_line1":"42 Sevenoaks St","address_line2":null,"address_city":"Lathlain","address_postcode":"6454","address_state":"WA","address_country":"Australia"},"transfer":null}}'
    end

    def create_with_card_request do
      "{\"ip_address\":\"127.0.0.1\",\"email\":\"hagrid@hogwarts.wiz\",\"description\":\"Dragon Eggs\",\"currency\":\"AUD\",\"card\":{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":6000,\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"},\"amount\":500}"
    end

  end
end
