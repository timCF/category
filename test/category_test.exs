defmodule CategoryTest do
  use ExUnit.Case
  doctest Category

  test "greets the world" do
    assert Category.hello() == :world
  end
end
