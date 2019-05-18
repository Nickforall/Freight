defmodule Freight.UnitTests.Integrations.EctoTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset
  import Freight.Helpers.Test

  alias Freight.Integrations
  alias Freight.Payload.ErrorPayload

  defmodule User do
    @moduledoc false
    use Ecto.Schema

    schema "user" do
      field(:email, :string)
      field(:name, :string)
      field(:age, :integer)
    end

    def changeset(user, params \\ %{}) do
      user
      |> cast(params, [:email, :name, :age])
      |> validate_required([:email, :name, :age])
      |> validate_length(:name, min: 2)
      |> validate_inclusion(:age, 21..100, message: "You are not old enough!")
    end
  end

  describe "Ecto integration convert_error/1" do
    test "succeeds with single changeset error" do
      errors =
        User.changeset(%User{}, %{
          email: "nick@awkward.co",
          name: "Nick Vernij",
          age: 19
        })
        |> Integrations.Ecto.convert_error()

      assert errors == ["You are not old enough!"]
    end

    test "succeeds with multiple changeset errors" do
      errors =
        User.changeset(%User{}, %{
          age: 21
        })
        |> Integrations.Ecto.convert_error()

      assert errors == ["email can't be blank", "name can't be blank"]
    end

    test "successfully deals with variables in changeset errors" do
      errors =
        User.changeset(%User{}, %{
          age: 21,
          email: "nick@awkward.co",
          name: "."
        })
        |> Integrations.Ecto.convert_error()

      assert errors == ["name should be at least 2 character(s)"]
    end
  end

  describe "ErrorPayload.create_payload/1" do
    test "converts a single changeset to a list of errors" do
      payload =
        ErrorPayload.create_payload(
          User.changeset(%User{}, %{
            age: 21,
            name: "-"
          })
        )

      payload
      |> assert_has_error?("email can't be blank")
      |> assert_has_error?("name should be at least 2 character(s)")
    end

    test "converts a changelist combined with other errors to a list of errors" do
      payload =
        ErrorPayload.create_payload([
          User.changeset(%User{}, %{
            age: 21,
            name: "-"
          }),
          "Hello, world"
        ])

      payload
      |> assert_has_error?("email can't be blank")
      |> assert_has_error?("name should be at least 2 character(s)")
      |> assert_has_error?("Hello, world")
    end
  end
end
