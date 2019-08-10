defmodule Category.TypeClass do
  defmacro __using__(opts) do
    quote location: :keep do
      use Category.TypeClass.Functor, unquote(opts)
      use Category.TypeClass.Monad, unquote(opts)
      use Category.TypeClass.Applicative, unquote(opts)
    end
  end

  defmacro define_using do
    quote location: :keep do
      defmacro __using__(opts) do
        as =
          case opts do
            [] -> :import
            [as: x] -> x
          end

        module_alias =
          [
            __MODULE__
            |> Module.split()
            |> List.last()
          ]
          |> Module.concat()

        case as do
          :import ->
            quote location: :keep do
              require unquote(__MODULE__), as: unquote(module_alias)
              import unquote(__MODULE__)
            end

          :require ->
            quote location: :keep do
              require unquote(__MODULE__), as: unquote(module_alias)
            end
        end
      end
    end
  end
end
