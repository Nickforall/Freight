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
    %{Absinthe.Resolution.put_result(resolution, {:ok, result}) | errors: []}
  end

  @doc """
  Builds the default error object, and puts this in the config of freight.

  **NOTE: calling this overwrites your config**


  ## Default error object

  ```
  object :payload_error do
    field(:message, type: :string)
  end
  ```

  """
  defmacro build_error_object_default() do
    Application.put_env(:freight, :error_object, :payload_error)

    quote do
      object :payload_error do
        field(:message, type: :string)
      end
    end
  end

  @doc """
  Defines a payload object type with a given name and fields

  ## Error object

  By default an error object will be generated in build_error_object_default/0.

  If you'd like to use a custom error object, configure this in your config.exs:
  ```
  config :freight,
    # where :user_error is the name of the type you'd like to use as an error object
    error_object: :user_error
  ```

  Keyword list and map errors are automatically mapped to your error.
  Cangeset and string errors are mapped to the `message` property.

  ## Usage

  `define_payload(:user_payload, user: :user, comment: :comment)`

  creates the equilevant of

  ```elixir
  object :user_payload do
    field(:successful,
      type: non_null(:boolean),
      description: "Indicates whether the mutation completed successfully or not."
    )

    field(:errors,
      type: list_of(:payload_error),
      description: "A list of errors, raised when executing this migrations."
    )

    field(:user, type: :user)
    field(:comment, type: :comment)
  end
  ```
  """
  defmacro define_payload(name, fields \\ []) do
    quote location: :keep do
      # if there hasn't been a error object defined, we define the default one
      unquote do
        if is_nil(Freight.error_object()) do
          quote do
            build_error_object_default()
          end
        end
      end

      # define the payload
      object unquote(name) do
        field(:successful,
          type: :boolean,
          description: "Indicates whether the mutation completed successfully or not."
        )

        field(:errors,
          type: non_null(list_of(unquote(Freight.error_object()))),
          description: "A list of errors, raised when executing this migrations."
        )

        # loop through fields
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
