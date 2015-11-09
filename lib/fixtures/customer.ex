defmodule PinElixirTest.Fixtures.Customer do
  def create do
    '{"response":{"token":"cus__03Cn1lSk3offZ0IGkwpCg","email":"foo@example.com","created_at":"2013-06-12T10:08:30Z","card":{"token":"card_qMwnMfpG-olOhfJeyxmrcg","display_number":"XXXX-XXXX-XXXX-0000","scheme":"master","address_line1":"123 Main St","address_line2":"","address_city":"Melbourne","address_postcode":"3000","address_state":"Victoria","address_country":"Australia"}}}'
  end

  def create_with_email_request do
    "{\"email\":\"foo@example.com\",\"card\":{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":\"H0G\",\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"}}"
  end

  def create_with_card_token_request do
    "{\"email\":\"foo@example.com\",\"card_token\":\"abc_a123\"}"
  end

  def create_error_request do
    "{\"email\":\"\",\"card\":{\"number\":4200000000000000,\"name\":\"Rubius Hagrid\",\"expiry_year\":2016,\"expiry_month\":\"10\",\"cvc\":456,\"address_state\":\"WA\",\"address_postcode\":\"H0G\",\"address_line1\":\"The Game Keepers Cottage\",\"address_country\":\"Straya\",\"address_city\":\"Hogwarts\"}}"
  end


  def create_error_response do
    '{"error":"invalid_resource","error_description":"One or more parameters were missing or invalid.","messages":[{"param":"email","code":"email_invalid","message":"Email can\'t be blank"}]}'
  end

end
