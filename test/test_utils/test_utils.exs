defmodule PinElixirTest.Utils do
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

  def response(body, status \\ 200) do
    %HyperMock.Response{
      body: body,
      status: status
    }
  end
end
