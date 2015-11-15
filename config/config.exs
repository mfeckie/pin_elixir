use Mix.Config

config :logger,
  compile_time_purge_level: :info

if Mix.env == :test do
  config :pin_elixir,
    api_key: System.get_env("PIN_API_KEY"),
    pin_url: "test-api.pin.net.au/1"
end
