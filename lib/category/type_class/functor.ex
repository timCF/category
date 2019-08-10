defmodule Category.TypeClass.Functor do
  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep t(x) :: Category.t(x)

  @callback functor_fmap((a -> b), t(a)) :: t(b)

  defmacro fmap(f, it) do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      {:module, mod} = :erlang.fun_info(it, :module)
      mod.functor_fmap(Kare.curry(f), it)
    end
  end

  defmacro f <|> it do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      unquote(__MODULE__).fmap(it, f)
    end
  end
end
