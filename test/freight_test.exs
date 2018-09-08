defmodule FreightTest do
  use ExUnit.Case
  doctest Freight

  test "greets the world" do
    assert Freight.hello() == :world
  end
end
