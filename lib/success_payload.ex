defmodule Freight.Payload.SuccessPayload do
  @base_success_payload %{
    successful: true
  }

  @doc """
  Manually generates a map representing a successful object.

  Omitted value will be returned as null in your graphql response.
  There is currently no checking for whether all values are provided.

  ## Usage

    ```elixir
      create_payload(user: %User{})
    ```

    will return the following map

    ```elixir
    %{
      successful: true,
      user: %User{}
    }
    ```
  """
  def create_payload(list) when is_list(list) do
    unless Keyword.keyword?(list),
      do: raise(ArgumentError, "You must supply a keyword list or object to build a payload")

    Enum.into(list, %{})
    |> Map.merge(@base_success_payload)
  end

  def create_payload(map) when is_map(map) do
    Map.merge(map, @base_success_payload)
  end

  def create_payload(nil) do
    @base_success_payload
  end

  def create_payload(_),
    do: raise(ArgumentError, "You must supply a keyword list or object to build a payload")
end
