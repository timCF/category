defmodule Category.TypeClass.Monad do
  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep t(x) :: Category.t(x)

  @callback monad_bind(t(a), (a -> t(b))) :: t(b)

  defmacro bind(it, f) do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      {:module, mod} = :erlang.fun_info(it, :module)
      mod.monad_bind(it, f)
    end
  end

  defmacro it ~>> f do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      unquote(__MODULE__).bind(it, f)
    end
  end
end
