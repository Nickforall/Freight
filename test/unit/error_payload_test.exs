defmodule Freight.UnitTests.ErrorPayloadTest do
  use ExUnit.Case, async: true

  alias Freight.Payload.ErrorPayload

  describe "error payload succeeds" do
    test "with single string" do
      map = ErrorPayload.create_payload("Hello, world")

      assert Map.get(map, :errors) == ["Hello, world"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple strings" do
      map = ErrorPayload.create_payload(["Hello, world", "Bye, mars"])

      assert Map.get(map, :errors) == ["Hello, world", "Bye, mars"]
      assert Map.get(map, :successful) == false
    end

    test "with map" do
      map = ErrorPayload.create_payload(%{message: "test? hello?"})

      assert Map.get(map, :errors) == ["test? hello?"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple maps" do
      map = ErrorPayload.create_payload([%{message: "test"}, %{message: "sup there"}])

      assert Map.get(map, :errors) == ["test", "sup there"]
      assert Map.get(map, :successful) == false
    end

    test "with keyword list" do
      map = ErrorPayload.create_payload(message: "hello, testy world")

      assert Map.get(map, :errors) == ["hello, testy world"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple keyword lists" do
      map =
        ErrorPayload.create_payload([
          [message: "hello, testy world"],
          [message: "why would one want this"]
        ])

      assert Map.get(map, :errors) == ["hello, testy world", "why would one want this"]
      assert Map.get(map, :successful) == false
    end
  end

  describe "error payload raises" do
    test "with single invalid type" do
      assert_raise ArgumentError,
                   fn -> ErrorPayload.create_payload(1) end
    end

    test "with multiple invalid types" do
      assert_raise ArgumentError,
                   fn ->
                     ErrorPayload.create_payload([1, true, 1.0, :test])
                   end
    end

    test "with map without message" do
      assert_raise ArgumentError,
                   ~r/A map must have the `message` key defined to be converted to an error/,
                   fn -> ErrorPayload.create_payload(%{}) end
    end

    test "with list with plain lists" do
      assert_raise ArgumentError, ~r/Expected a keyword list, but got a plain list/, fn ->
        ErrorPayload.create_payload([[1], [2]])
      end
    end
  end
end
