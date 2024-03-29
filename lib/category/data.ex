defmodule Category.Data do
  defmacro __using__(_) do
    quote location: :keep do
      require Category.Data.Maybe, as: Maybe
      :ok
    end
  end
end
