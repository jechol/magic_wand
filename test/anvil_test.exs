defmodule AnvilTest do
  use ExUnit.Case
  doctest Anvil

  test "greets the world" do
    assert Anvil.hello() == :world
  end
end
