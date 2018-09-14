defmodule Freight.Helpers.Test do
  import ExUnit.Assertions

  @moduledoc """
  These helpers can be used in your ExUnit tests, while dealing with mutation payloads.

  ## Example
  ```
  test "throws errors" do
      map
      |> assert_unsuccessful?()
      |> assert_has_error?("this does not work this way")
      |> assert_has_error?("and neither does this")
  end
  ```
  """

  @doc """
  Asserts whether the mutation was successful
  """
  def assert_successful?(map) do
    assert Map.get(map, :successful)
    map
  end

  @doc """
  Asserts whether the mutation was not successful
  """
  def assert_unsuccessful?(map) do
    assert !Map.get(map, :successful)
    map
  end

  @doc """
  Checks whether the mutation returned an error with the given message in its payload
  """
  def assert_has_error?(map, message) do
    assert_unsuccessful?(map)
    errors = Map.get(map, :errors, [])

    assert Enum.any?(errors, fn x ->
             Map.get(x, :message) == message
           end)

    map
  end
end
