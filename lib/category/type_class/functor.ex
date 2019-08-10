defmodule Category.TypeClass.Functor do
  import Category.TypeClass
  define_using()

  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep t(x) :: Category.t(x)

  @callback functor_fmap((a -> b), t(a)) :: t(b)

  defmacro fmap(f, it) do
    quote location: :keep do
      it = unquote(it)
      {:module, mod} = :erlang.fun_info(it, :module)

      unquote(f)
      |> Kare.curry()
      |> mod.functor_fmap(it)
    end
  end

  defmacro f <|> it do
    quote location: :keep do
      unquote(__MODULE__).fmap(unquote(f), unquote(it))
    end
  end
end
