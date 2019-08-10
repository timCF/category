defmodule Category.TypeClass.Applicative do
  @typep a :: Category.a()
  @typep b :: Category.b()
  @typep t(x) :: Category.t(x)

  @callback applicative_ap(t((a -> b)), t(a)) :: t(b)

  defmacro ap(mf, it) do
    quote location: :keep, bind_quoted: [it: it, mf: mf] do
      {:module, mod} = :erlang.fun_info(it, :module)

      (&Kare.curry/1)
      |> Category.TypeClass.Functor.fmap(mf)
      |> mod.applicative_ap(it)
    end
  end

  defmacro f <~> it do
    quote location: :keep, bind_quoted: [it: it, f: f] do
      unquote(__MODULE__).ap(f, it)
    end
  end
end
