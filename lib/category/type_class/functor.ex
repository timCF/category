defmodule Category.TypeClass.Functor do
  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep t(x) :: Category.t(x)

  @callback functor_fmap(t(a), (a -> b)) :: t(b)

  defmacro fmap(it, f) do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      {:module, mod} = :erlang.fun_info(it, :module)
      mod.functor_fmap(it, Kare.curry(f))
    end
  end

  defmacro it <|> f do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      unquote(__MODULE__).fmap(it, f)
    end
  end
end
