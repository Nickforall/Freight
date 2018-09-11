defmodule Freight.UnitTests.SuccessPayloadTest do
  use ExUnit.Case, async: true

  alias Freight.Payload.SuccessPayload

  describe "success payload succesfully converts" do
    test "ok tuple with keyword list" do
      map = SuccessPayload.create_payload(user: "user", comment: %{body: "yo"})

      assert Map.get(map, :user) == "user"
      assert Map.get(map, :comment) == %{body: "yo"}
      assert is_nil(Map.get(map, :errors))
      assert Map.get(map, :successful) == true
    end

    test "ok tuple with map" do
      map = SuccessPayload.create_payload(%{user: "user", comment: %{body: "yo"}})

      assert Map.get(map, :user) == "user"
      assert Map.get(map, :comment) == %{body: "yo"}
      assert is_nil(Map.get(map, :errors))
      assert Map.get(map, :successful) == true
    end
  end
end
