defmodule PinElixirTest.Fixtures.Refund do
  def refund_success_response do
    """
    {
    "response":
        {
          "token": "rf_ERCQy--Ay6o-NKGiUVcKKA",
          "success": null,
          "amount": 400,
          "currency": "USD",
          "charge": "ch_bZ3RhJnIUZ8HhfvH8CCvfA",
          "created_at": "2012-10-27T13:00:00Z",
          "error_message": null,
          "status_message": "Pending"
        }
    }
    """
  end

  def partial_refund_success_response do
  """
  {
  "response":
    {
      "token": "rf_ERCQy--Ay6o-NKGiUVcKKA",
      "success": null,
      "amount": 200,
      "currency": "USD",
      "charge": "ch_bZ3RhJnIUZ8HhfvH8CCvfA",
      "created_at": "2012-10-27T13:00:00Z",
      "error_message": null,
      "status_message": "Pending"
    }
  }
  """
  end

  def refund_failure_response do
    """
    {
      "error": "insufficient_pin_balance",
      "error_description": "Refund amount is more than your available Pin Payments balance."
    }
    """
  end

  def get_all_response do
    """
    {
      "response": [
        {
          "token": "rf_ERCQy--Ay6o-NKGiUVcKKA",
          "success": null,
          "amount": 400,
          "currency": "USD",
          "charge": "ch_bZ3RhJnIUZ8HhfvH8CCvfA",
          "created_at": "2012-10-27T13:00:00Z",
          "error_message": null,
          "status_message": "Pending"
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

  def get_refunds_response, do: get_all_response

end
