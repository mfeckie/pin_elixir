use Mix.Config

config :pin_elixir,
  api_key: System.get_env("PIN_API_KEY"),
  pin_url: "test-api.pin.net.au/1"
