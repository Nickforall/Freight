defmodule Freight.UnitTests.ErrorPayloadTest do
  use ExUnit.Case, async: true

  alias Freight.Payload.ErrorPayload

  describe "error payload succeeds" do
    test "with single string" do
      map = ErrorPayload.create_payload({:error, "Hello, world"})

      assert Map.get(map, :errors) == ["Hello, world"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple strings" do
      map = ErrorPayload.create_payload({:error, ["Hello, world", "Bye, mars"]})

      assert Map.get(map, :errors) == ["Hello, world", "Bye, mars"]
      assert Map.get(map, :successful) == false
    end

    test "with map" do
      map = ErrorPayload.create_payload({:error, [%{message: "test? hello?"}]})

      assert Map.get(map, :errors) == ["test? hello?"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple maps" do
      map = ErrorPayload.create_payload({:error, [%{message: "test"}, %{message: "sup there"}]})

      assert Map.get(map, :errors) == ["test", "sup there"]
      assert Map.get(map, :successful) == false
    end

    test "with keyword list" do
      map = ErrorPayload.create_payload({:error, message: "hello, testy world"})

      assert Map.get(map, :errors) == ["hello, testy world"]
      assert Map.get(map, :successful) == false
    end

    test "with multiple keyword lists" do
      map =
        ErrorPayload.create_payload(
          {:error, [[message: "hello, testy world"], [message: "why would one want this"]]}
        )

      assert Map.get(map, :errors) == ["hello, testy world", "why would one want this"]
      assert Map.get(map, :successful) == false
    end
  end
end
