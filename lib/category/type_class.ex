defmodule Category.TypeClass do
  defmacro __using__(_) do
    quote location: :keep do
      require Category.TypeClass.Functor, as: Functor
    end
  end
end
