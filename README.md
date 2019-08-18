# Category

Functors, Monads and Applicatives with real encapsulation

<img src="priv/img/logo.jpeg" width="225"/>

## Installation

The package can be installed by adding `category` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:category, "~> 0.1.0"}
  ]
end
```

## Translation Table

| Type Class  | Function  | Haskell | Elixir |
|-------------|-----------|---------|--------|
| Functor     | fmap      |   <$>   |   <~   |
| Functor     | flip fmap |   <&>   |   ~>   |
| Monad       | bind      |   >>=   |   >>>  |
| Applicative | ap        |   <*>   |   <<~  |

<br>
<p align="center">
  <tt>
    Made with ❤️ by
    <a href="https://itkach.uk" target="_blank">Ilja Tkachuk</a>
    aka
    <a href="https://github.com/timCF" target="_blank">timCF</a>
  </tt>
</p>
