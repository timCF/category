defmodule Category.TypeClass.Functor do
  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep f(x) :: Category.f(x)

  @callback functor_fmap(f(a), (a -> b)) :: f(b)

  def fmap(it, f) do
    {:module, mod} = :erlang.fun_info(it, :module)
    mod.functor_fmap(it, f)
  end
end
