defmodule PinElixir.Utils.Response do
  import Poison, only: [:decode!]

  def decode(body) do
    Poison.decode!(body, keys: :atoms)
  end

  def to_error_tuple(body) do
    {:error, decode(body)}
  end


end
