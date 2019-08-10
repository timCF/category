defmodule Category.TypeClass do
  defmacro __using__(_) do
    quote location: :keep do
      require Category.TypeClass.Functor, as: Functor
      require Category.TypeClass.Monad, as: Monad
    end
  end
end
