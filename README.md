# Category

Functors, Monads and Applicatives with real encapsulation

<img src="priv/img/logo.jpeg" width="225"/>

## Translation Table

| Type Class  | Function  | Haskell | Elixir |
|-------------|-----------|---------|--------|
| Functor     | fmap      |   <$>   |   <~   |
| Functor     | flip fmap |   <&>   |   ~>   |
| Monad       | bind      |   >>=   |   >>>  |
| Applicative | ap        |   <*>   |   <<~  |

## Usage

As example of Functor, Monad and Applicative type classes usage we will consider classic sum type Maybe which implements all of them. Maybe is generic type which accepts one other type as parameter. It's very similar to List type in this meaning of parametricity: `@type t :: [String.t]` is List of strings, `@type t :: Maybe.t(String.t)` is Maybe String, `@type t :: [a]` is List of `a`, `@type t :: Maybe.t(a)` is Maybe `a`. Essence of Maybe is representation of optional values, so this data type have 2 constructors. Here is example of `Maybe Integer` type:

```elixir
iex> use Category
:ok
iex> j = Maybe.just(1)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> n = Maybe.nothing()
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> Maybe.is?(j)
true
iex> Maybe.is?(n)
true
```

There is significant difference between Maybe type `@type t :: Maybe.t(integer)` and more common in Elixir `@type t :: nil | integer`. As you can see, values `Maybe.just(1)` and `Maybe.nothing()` are values of the **same** type, which means that they can be composed efficiently. But values `1` and `nil` are values of **different** types (Integer and Atom), which means that they can't be composed efficiently. Let's consider examples of this efficient or inefficient compositions one by one.

## Functor

Let's say we have value `x` of type `Maybe.t(integer)`. And we have a function which accepts Integer and returns Integer, for example `increment = &(&1 + 1)`. How do we apply `increment` to `x`? Without Maybe type code will look like this:

```elixir
case x do
  nil -> x
  _ -> increment.(x)
end
```

I can't say it is beautiful or convenient. But if we will use Maybe type which implements Functor behaviour, we can use **fmap** function (or its infix versions **<~** or **~>**) which will apply given function to internal state of Maybe in case of `Maybe.just(a)` or do nothing in case of `Maybe.nothing`. Final code will look much better:

```elixir
Functor.fmap(increment, x)
```

or

```elixir
increment <~ x
```

or

```elixir
x ~> increment
```

Let's show how it works in iex:

```elixir
iex> use Category
:ok
iex> j = Maybe.just(1)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> n = Maybe.nothing()
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> increment = &(&1 + 1)
#Function<6.128620087/1 in :erl_eval.expr/5>
iex> increment <~ j |> Maybe.get!
2
iex> increment <~ n |> Maybe.is_nothing?
true
```

Btw, as I mentioned before, List data type also implements Functor type class, and in reality every Elixir or Erlang developer already knows what is Functor and how it works, because `map = fmap`. So if you understand List data type and generic `map` function then you already understand Functors:

```elixir
iex> Enum.map([1, 2, 3], &(&1 + 1))
[2, 3, 4]
```

## Applicative

Applicative type class feels like some kind of generalization of Functor. Example is pretty similar to previous one. But in this case we have **two** values `x` and `y` of type `Maybe.t(integer)`. And we have a function which accepts **two** integers and returns integer, for example `sum = &Kernel.+/2`. How do we apply `sum` to `x` and `y`? Without Maybe code will look like:

```elixir
case is_nil(x) or is_nil(y) do
  true -> nil
  false -> sum.(x, y)
end
```

As you can see it looks ugly even with arity 2. Imagine how it will look with arity 10? But we can use Maybe. It implements Applicative behaviour which means that we can use **ap** (or its infix version **<<~**). We know how `fmap` applies function to Maybe value, `ap` is pretty similar - in our example it applies Maybe function to Maybe value. It's not so interesting itself (because there are not so many practical cases when we have Maybe function, right?), but it is very useful in combinations with `fmap`. Our final code will look like

```elixir
sum <~ x <<~ y
```

Let's show how it works in iex:

```elixir
iex> use Category
:ok
iex> x = Maybe.just(1)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> y = Maybe.just(2)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> n = Maybe.nothing()
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> sum = &Kernel.+/2
&:erlang.+/2
iex> sum <~ x <<~ y |> Maybe.get!
3
iex> sum <~ x <<~ n |> Maybe.is_nothing?
true
iex> sum <~ n <<~ y |> Maybe.is_nothing?
true
```

In example above, `sum` function has arity 2, but of course we can compute functions with bigger arities using applicative notation, for example:

```elixir
iex> use Category
:ok
iex> f = fn x, y, z -> x * x + y * y + z * z end
#Function<18.128620087/3 in :erl_eval.expr/5>
iex> x = Maybe.just(1)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> y = Maybe.just(2)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> z = Maybe.just(3)
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> n = Maybe.nothing()
#Function<2.96330962/2 in Category.Data.Maybe.eval/2>
iex> f <~ x <<~ y <<~ z |> Maybe.get!
14
iex> f <~ x <<~ n <<~ z |> Maybe.is_nothing?
true
```

Btw, List data type also implements Applicative type class! In Elixir there is no direct equivalent like it was for `fmap`, but Applicative `ap` for List data type more or less corresponds to comprehensions like this:

```elixir
iex> for f <- [&(&1 + 1), &(&1 * 2)], x <- [1, 2, 3], do:  f.(x)
[2, 3, 4, 2, 4, 6]
```

## Monad

Let's say we have a program which accepts Maybe Integer as input, but this program is able to work only with natural numbers. To make code safe, we have to use function like this:

```elixir
int2mnat = fn
  x when is_integer(x) and x >= 0 -> Maybe.just(x)
  _ -> Maybe.nothing()
end
```

It completely make sense because there are no natural numbers corresponding to negative integers, so we have to use Maybe data type here. Function `int2mnat` accepts Integer and returns Maybe Natural as we want. But look, input of our program is Maybe Integer, not Integer, how do we deal with that? Without Monad type class, code will look like:

```elixir
case Maybe.is_just?(x) do
  true -> x |> Maybe.get! |> int2mnat.()
  false -> x
end
```

But as we know, Maybe implements Monad type class, so we can use **bind** function (or **>>>** infix equivalent) to make code better:

```elixir
x >>> int2mnat
```

Let's show how it works in iex:

```elixir
iex> use Category
:ok
iex> int2mnat = fn
...>   x when is_integer(x) and x >= 0 -> Maybe.just(x)
...>   _ -> Maybe.nothing()
...> end
#Function<6.128620087/1 in :erl_eval.expr/5>
iex> j0 = Maybe.just(1)
#Function<2.85804733/2 in Category.Data.Maybe.eval/2>
iex> j1 = Maybe.just(-1)
#Function<2.85804733/2 in Category.Data.Maybe.eval/2>
iex> n = Maybe.nothing()
#Function<2.85804733/2 in Category.Data.Maybe.eval/2>
iex> j0 >>> int2mnat |> Maybe.get!
1
iex> j1 >>> int2mnat |> Maybe.is_nothing?
true
iex> n >>> int2mnat |> Maybe.is_nothing?
true
```

And as you already guessed, List data type also implements Monad type class! For List data type in Elixir, `bind = flat_map`:

```elixir
iex> f = &(&1 > 1 && [&1, &1] || [])
#Function<6.128620087/1 in :erl_eval.expr/5>
iex> Enum.flat_map([1, 2, 3], f)
[2, 2, 3, 3]
```

So if you know how `flat_map` works, you already understand monads!

## Installation

The package can be installed by adding `category` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:category, "~> 0.1.0"}
  ]
end
```

<br>
<p align="center">
  <tt>
    Made with ❤️ by
    <a href="https://itkach.uk" target="_blank">Ilja Tkachuk</a>
    aka
    <a href="https://github.com/timCF" target="_blank">timCF</a>
  </tt>
</p>
