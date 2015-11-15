defmodule PinElixirTest.Fixtures.Balance do
  def get_response do
    """
    {
      "response": {
        "available": [
          {
            "amount": 400,
            "currency": "AUD"
          }
        ],
        "pending": [
          {
            "amount": 1200,
            "currency": "AUD"
          }
        ]
      }
    }
    """
  end
end
