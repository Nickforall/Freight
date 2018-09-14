defmodule Freight.UnitTests.ErrorPayloadTest do
  use ExUnit.Case, async: true

  alias Freight.Payload.ErrorPayload

  import Freight.Helpers.Test

  describe "error payload succeeds" do
    test "with single string" do
      map = ErrorPayload.create_payload("Hello, world")

      map
      |> assert_has_error?("Hello, world")
    end

    test "with multiple strings" do
      map = ErrorPayload.create_payload(["Hello, world", "Bye, mars"])

      map
      |> assert_has_error?("Hello, world")
      |> assert_has_error?("Bye, mars")
    end

    test "with map" do
      map = ErrorPayload.create_payload(%{message: "test? hello?"})

      map
      |> assert_has_error?("test? hello?")
    end

    test "with multiple maps" do
      map = ErrorPayload.create_payload([%{message: "test"}, %{message: "sup there"}])

      map
      |> assert_has_error?("test")
      |> assert_has_error?("sup there")
    end

    test "with keyword list" do
      map = ErrorPayload.create_payload(message: "hello, testy world")

      map
      |> assert_has_error?("hello, testy world")
    end

    test "with multiple keyword lists" do
      map =
        ErrorPayload.create_payload([
          [message: "hello, testy world"],
          [message: "why would one want this"]
        ])

      map
      |> assert_has_error?("hello, testy world")
      |> assert_has_error?("why would one want this")
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

    test "with keyword list without message" do
      assert_raise ArgumentError,
                   ~r/A keyword list must have the `message` key defined to be converted to an error/,
                   fn -> ErrorPayload.create_payload(test: 1) end
    end

    test "with list with plain lists" do
      assert_raise ArgumentError, ~r/Expected a keyword list, but got a plain list/, fn ->
        ErrorPayload.create_payload([[1], [2]])
      end
    end
  end
end
