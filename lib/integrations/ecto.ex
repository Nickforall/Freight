defmodule Freight.Integrations.Ecto do
  @moduledoc """
  The ecto integration converts Ecto changeset errors into error messages.
  """

  import Ecto.Changeset, only: [traverse_errors: 2]
  alias Ecto.Changeset

  @doc false
  defdelegate is_custom_error_message?(atom, message),
    to: Freight.Integrations.Ecto.IsCustomErrorMessage

  @doc """
  Converts a changeset to a list of error strings
  """
  def convert_error(%Changeset{} = changeset) do
    changeset
    |> traverse_errors(&traverse_errors_map/3)
    |> build_error_list
  end

  # converts to string without raising
  defp safe_to_string(term) when is_list(term) and not is_binary(term) do
    inspect(term)
  end

  defp safe_to_string(term) do
    case String.Chars.impl_for(term) do
      nil -> inspect(term)
      _ -> to_string(term)
    end
  end

  # https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2
  defp traverse_errors_map(_changeset, field, {msg, opts} = error) do
    validation = Keyword.get(opts, :validation)

    case is_custom_error_message?(validation, msg) do
      true ->
        reduce_options_onto_message(error)

      false ->
        msg = reduce_options_onto_message(error)
        Enum.join([field_name_to_string(field), msg], " ")
    end
  end

  defp field_name_to_string(field) do
    case Freight.lower_camelize_field_name?() do
      true -> field |> Atom.to_string() |> Absinthe.Utils.camelize(lower: true)
      false -> Atom.to_string(field)
    end
  end

  defp reduce_options_onto_message({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", safe_to_string(value))
    end)
  end

  # maps key-value map where keys are field names and values are errors to a list
  defp build_error_list(map) do
    Enum.reduce(map, [], fn {_, value}, acc -> acc ++ value end)
  end
end
