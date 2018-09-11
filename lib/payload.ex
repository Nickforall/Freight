defmodule Freight.Payload do
  use Absinthe.Schema.Notation

  alias Freight.Payload.ErrorPayload
  alias Freight.Payload.SuccessPayload

  @doc """
    Absinthe middleware function that creates a payload

    ## Usage:

    Below shows the usage in an absinthe scheme

    ```elixir
      @desc "Delete a comment"
      field :delete_comment, :comment_delete_payload do
        arg(:id, non_null(:id))
        resolve(&CommentsResolver.delete_comment/3)

        middleware(&build_payload/2)
      end
    ```
  """
  def build_payload(%{value: value, errors: []} = resolution, _config) do
    result = SuccessPayload.create_payload(value)
    Absinthe.Resolution.put_result(resolution, {:ok, result})
  end

  def build_payload(%{errors: errors} = resolution, _config) do
    result = ErrorPayload.create_payload(errors)
    %{ Absinthe.Resolution.put_result(resolution, {:ok, result}) | errors: [] }
  end

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
