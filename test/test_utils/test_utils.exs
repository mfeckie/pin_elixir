defmodule PinElixirTest.Utils do
  def response(body, status \\ 200) do
    %HyperMock.Response{
      body: body,
      status: status
    }
  end
end
