defmodule Category.Data.MaybeTest do
  use ExUnit.Case
  use Category
  doctest Maybe

  setup do
    {:ok, %{just: Maybe.just(1), nothing: Maybe.nothing()}}
  end

  test "constructors", %{just: just, nothing: nothing} do
    assert Maybe.is?(just)
    assert Maybe.is?(nothing)
  end

  test "checkers", %{just: just, nothing: nothing} do
    assert Maybe.is_just?(just)
    assert Maybe.is_nothing?(nothing)

    refute Maybe.is_just?(nothing)
    refute Maybe.is_nothing?(just)
  end

  test "fetch", %{just: just, nothing: nothing} do
    assert 1 == Maybe.fetch(just)
    assert nil == Maybe.fetch(nothing)
  end

  test "fetch!", %{just: just, nothing: nothing} do
    assert 1 == Maybe.fetch!(just)

    assert_raise RuntimeError,
                 "Can't fetch from Category.Data.Maybe.nothing",
                 fn ->
                   Maybe.fetch!(nothing)
                 end
  end

  test "fmap just", %{just: j0} do
    assert Maybe.is?(j0)
    assert 1 == Maybe.fetch!(j0)

    j1 = Functor.fmap(j0, &(&1 * 3))
    assert Maybe.is?(j1)
    assert 3 == Maybe.fetch!(j1)

    j2 = Functor.fmap(j1, fn _ -> :hello end)
    assert Maybe.is?(j2)
    assert :hello == Maybe.fetch!(j2)
  end

  test "fmap nothing", %{nothing: n0} do
    assert Maybe.is_nothing?(n0)

    n1 = Functor.fmap(n0, &(&1 * 3))
    assert Maybe.is_nothing?(n1)

    n2 = Functor.fmap(n1, fn _ -> :hello end)
    assert Maybe.is_nothing?(n2)

    n3 = Functor.fmap(n1, fn _ -> raise("BANG!!!") end)
    assert Maybe.is_nothing?(n3)
  end

  test "bind just", %{just: j0} do
    assert Maybe.is?(j0)
    assert 1 == Maybe.fetch!(j0)

    j1 = Monad.bind(j0, &Maybe.just(&1 * 3))
    assert Maybe.is?(j1)
    assert 3 == Maybe.fetch!(j1)

    j2 = Monad.bind(j1, fn _ -> Maybe.nothing() end)
    assert Maybe.is?(j2)
    assert Maybe.is_nothing?(j2)
  end

  test "bind nothing", %{nothing: n0} do
    assert Maybe.is_nothing?(n0)

    n1 = Monad.bind(n0, &Maybe.just(&1 * 3))
    assert Maybe.is_nothing?(n1)

    n2 = Monad.bind(n1, fn _ -> Maybe.just(:hello) end)
    assert Maybe.is_nothing?(n2)

    n3 = Monad.bind(n1, fn _ -> raise("BANG!!!") end)
    assert Maybe.is_nothing?(n3)
  end
end
