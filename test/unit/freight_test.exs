defmodule Freight.UnitTests.FreightTest do
  use ExUnit.Case, async: true

  describe "Freight error_object/0" do
    test "returns env" do
      Application.put_env(:freight, :error_object, :test)

      assert Freight.error_object() == :test
    end
  end
end
