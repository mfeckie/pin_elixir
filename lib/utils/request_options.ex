defmodule PinElixir.Utils.RequestOptions do
  @moduledoc false

  @api_key Application.get_env(:pin_elixir, :api_key)

  def with_auth do
    [basic_auth: {@api_key, ""}]
  end

  def with_auth(options) do
    List.flatten(with_auth, options)
  end
end
