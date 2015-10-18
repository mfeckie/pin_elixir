defmodule PinElixirTest.Support do
  use ExUnit.Case
  use Mix.Config
  alias PinElixir.Support

  test "gets api_key" do
    api_key = Support.get_config(:api_key)
    assert api_key == "ustPrxprRpnlHF1JlggRDg"
  end

  test "gets pin_url" do
    pin_url = Support.get_config(:pin_url)
    assert pin_url == "test-api.pin.net.au"
  end

end
