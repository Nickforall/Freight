defmodule Freight.Payload do
  use Absinthe.Schema.Notation

  alias Freight.Payload.ErrorPayload
  alias Freight.Payload.SuccessPayload

  def build_payload({:error, _} = tuple) do
    ErrorPayload.create_payload(tuple)
  end

  def build_payload({:ok, _} = tuple) do
    SuccessPayload.create_payload(tuple)
  end

  def build_payload(_),
    do: raise(ArgumentError, "Expected a tuple with either {:ok, _} or {:error, _}")

  @doc """
  Defines a payload object type with a given name and fields

  ## Usage

    define_payload(:user_payload, user: :user, comment: :comment)

  creates the equilevant of

  ```elixir
  object :user_payload do
    field(:successful,
      type: non_null(:boolean),
      description: "Indicates whether the mutation completed successfully or not."
    )

    field(:errors,
      type: list_of(:string),
      description: "A list of errors, raised when executing this migrations."
    )

    field(:user, type: :user)
    field(:comment, type: :comment)
  end
  ```
  """
  defmacro define_payload(name, fields \\ []) do
    quote do
      object unquote(name) do
        field(:successful,
          type: :boolean,
          description: "Indicates whether the mutation completed successfully or not."
        )

        field(:errors,
          type: list_of(:string),
          description: "A list of errors, raised when executing this migrations."
        )

        unquote(
          Enum.map(fields, fn {name, type_value} ->
            quote do
              field(unquote(name), type: unquote(type_value))
            end
          end)
        )
      end
    end
  end
end
