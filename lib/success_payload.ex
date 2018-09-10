defmodule Freight.Payload.SuccessPayload do
  @doc """
  Manually generates a map representing a successful object.

  Omitted value will be returned as null in your graphql response.
  There is currently no checking for whether all values are provided.

  ## Usage

    ```elixir
      create_payload({:ok, user: %User{}})
    ```

    will return the following map

    ```elixir
    %{
      successful: true,
      user: %User{}
    }
    ```
  """
  def create_payload({:ok, list}) when is_list(list) do
    unless Keyword.keyword?(list),
      do: raise(ArgumentError, "You must supply a keyword list or object in an ok tuple.")

    Enum.into(list, %{})
    |> Map.merge(%{
      successful: true
    })
  end

  def create_payload({:ok, map}) when is_map(map) do
    Map.merge(map, %{
      successful: true
    })
  end

  def create_payload(_),
    do: raise(ArgumentError, "You must supply a keyword list or object in an ok tuple.")
end
