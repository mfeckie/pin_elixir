defmodule PinElixir.Support do
  def get_config(key) do
    Application.get_env(:pin_elixir, key)
  end
end
