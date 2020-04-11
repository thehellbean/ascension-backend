defmodule AscensionWeb.BookAPI do
  @derive Jason.Encoder
  defstruct [:authors, :isbn, :title]
end
