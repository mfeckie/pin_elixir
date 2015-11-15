# PinElixir

**An elixir client for [PinPayments](https://pin.net.au/)**

## Installation

1. Add pin_elixir to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:pin_elixir, "~> 0.0.1"}]
    end
    ```

2. Ensure pin_elixir is started before your application:

    ``` elixir
    def application do
      [applications: [:pin_elixir]]
    end
    ```

3. Add the appropriate credentials and endpoints to your config files such as `dev.exs`

    ``` elixir
    config :pin_elixir,
    api_key: System.get_env("MY_API_KEY") || "my_super_secret_key",
    pin_url: "test-api.pin.net.au/1"
    ```


4. **Profit**
