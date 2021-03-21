defmodule ElixirappTest do
  use ExUnit.Case
  doctest Elixirapp

  test "greets the world" do
    assert Elixirapp.hello() == :world
  end
end
