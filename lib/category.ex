defmodule Category do
  @moduledoc """
  Functors, monads, applicatives
  """

  @opaque a :: __MODULE__.a()
  @opaque b :: __MODULE__.b()
  @opaque t(x) :: __MODULE__.t(x)

  defmacro __using__(_) do
    quote location: :keep do
      use Category.Data
      use Category.TypeClass
    end
  end
end
