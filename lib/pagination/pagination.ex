defmodule PinElixir.Pagination do
  defstruct [:current, :previous, :next, :per_page, :pages, :count]
end
