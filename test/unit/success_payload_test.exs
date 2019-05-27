defmodule Freight.UnitTests.SuccessPayloadTest do
  use ExUnit.Case, async: true

  import Freight.Helpers.Test

  alias Freight.Payload.SuccessPayload

  describe "success payload succesfully converts" do
    test "ok tuple with keyword list" do
      map = SuccessPayload.create_payload(user: "user", comment: %{body: "yo"})

      map
      |> assert_successful?()

      assert Map.get(map, :user) == "user"
      assert Map.get(map, :comment) == %{body: "yo"}
      assert Map.get(map, :errors) |> Enum.empty?()
    end

    test "ok tuple with map" do
      map = SuccessPayload.create_payload(%{user: "user", comment: %{body: "yo"}})

      map
      |> assert_successful?()

      assert Map.get(map, :user) == "user"
      assert Map.get(map, :comment) == %{body: "yo"}
      assert Map.get(map, :errors) |> Enum.empty?()
      assert Map.get(map, :successful) == true
    end

    test "ok tuple with nil" do
      map = SuccessPayload.create_payload(nil)

      map
      |> assert_successful?()

      assert Map.get(map, :errors) |> Enum.empty?()
    end
  end

  describe "success payload raises when" do
    test "a normal list is supplied" do
      assert_raise ArgumentError,
                   "You must supply a keyword list or object to build a payload.\nIf you don't want to return any payload values, supply `nil`.\n",
                   fn ->
                     SuccessPayload.create_payload([1, 2, 3])
                   end
    end

    test "an invalid value is supplied" do
      assert_raise ArgumentError,
                   "You must supply a keyword list or object to build a payload.\nIf you don't want to return any payload values, supply `nil`.\n",
                   fn ->
                     SuccessPayload.create_payload("invalid value")
                   end
    end
  end
end
