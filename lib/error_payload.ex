defmodule Freight.Payload.ErrorPayload do
  @doc """
  Manually generates a map representing a generic unsuccessful object.
  All customized result fields will not be defined, and thus returned as nil

  ## Usage

    ```elixir
      create_payload(["You are not signed in", "Something else"])
    ```

    will return the following map

    ```elixir
    %{
      successful: false,
      errors: ["You are not signed in", "Something else"]
    }
    ```
  """
  def create_payload(string) when is_binary(string) do
    error_payload([string])
  end

  def create_payload(list) when is_list(list) do
    cond do
      Keyword.keyword?(list) -> error_payload([convert_error(list, :keywordlist)])
      true -> error_payload(Enum.map(list, fn x -> convert_error(x) end))
    end
  end

  def create_payload(map) when is_map(map) do
    error_payload([convert_error(map)])
  end

  # matches if none of the above match
  def create_payload(value) do
    raise ArgumentError,
          raise_message(
            :error,
            "Argument of type #{value.t()} in error tuple could not be converted to an error"
          )
  end

  @doc """
  Converts any valid error value to an error object that can be supplied to the array of errors
  in a payload
  """
  # strings
  def convert_error(string) when is_binary(string) do
    string
  end

  # maps
  def convert_error(map) when is_map(map) do
    message = Map.get(map, :message)

    # if :message is not defined, raise error
    if is_nil(message),
      do:
        raise(
          ArgumentError,
          raise_message(
            :error,
            "A map must have the `message` key defined to be converted to an error"
          )
        )

    message
  end

  # keyword lists, rejects normal lists
  def convert_error(list) when is_list(list) do
    cond do
      Keyword.keyword?(list) ->
        convert_error(list, :keywordlist)

      true ->
        raise(
          ArgumentError,
          raise_message(
            :error,
            "Expected a keyword list, but got a plain list"
          )
        )
    end
  end

  # matches if none of the above match
  def convert_error(value) do
    raise ArgumentError,
          raise_message(
            :error,
            "Argument of type #{value.t()} in list could not be converted to an error"
          )
  end

  # assumes the value is confirmed to be a keyword list
  defp convert_error(keyword_list, :keywordlist) do
    message = Keyword.get(keyword_list, :message)

    # if :message is not defined, raise error
    if is_nil(message),
      do:
        raise(
          ArgumentError,
          raise_message(
            :error,
            "A keyword list must have the `message` key defined to be converted to an error"
          )
        )

    message
  end

  # helper to build an error payload value
  defp error_payload(errors) do
    %{
      successful: false,
      errors: errors
    }
  end

  # a basic error message used throughout error tuples
  defp raise_message(:error, additional) do
    """
    Your error tuple is invalid.

    > #{additional}

    ## Examples

    You can build error tuples the same way as you would in Absinthe. All Absinthe error tuples are
    valid in Freight too.

    Using an error message in a string
    `{:error, "An error message"}`

    Using keyword lists
    `{:error, message: "Some error message"}`

    Using maps
    `{:error, %{message: "This went horribly wrong"}}`

    All can be mixed up in a list
    `{:error, ["Hey", %{message: "This went horribly wrong"}]}`

    """
  end
end
