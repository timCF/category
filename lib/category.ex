defmodule Category do
  @moduledoc """
  Functors, monads, applicatives
  """

  defmacro __using__(opts) do
    quote location: :keep do
      use Category.Data
      use Category.TypeClass, unquote(opts)
      :ok
    end
  end
end
