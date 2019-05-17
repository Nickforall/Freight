defmodule Freight.Integrations.Ecto do
  @moduledoc """
  The ecto integration converts ecto changesets into error messages.

  You can pass a changeset as an error message, and Freight will interpret it and list its errors.
  """

  import Ecto.Changeset, only: [traverse_errors: 2]
  alias Ecto.Changeset

  @doc """
  Converts a changeset to a list of error strings
  """
  def convert_error(%Changeset{} = changeset) do
    changeset
    |> traverse_errors(&traverse_errors_map/3)
    |> build_error_list
  end

  # converts to string without raising
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
        Enum.join([Atom.to_string(field), msg], " ")
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

  # to be honest, i don't know if this is the best way to see if there are custom errors.
  # however i'm already in too deep now.
  defp is_custom_error_message?(:acceptance, "must be accepted"), do: false
  defp is_custom_error_message?(:confirmation, "does not match confirmation"), do: false
  defp is_custom_error_message?(:exclusion, "is reserved"), do: false
  defp is_custom_error_message?(:format, "has invalid format"), do: false
  defp is_custom_error_message?(:inclusion, "is invalid"), do: false
  defp is_custom_error_message?(:length, "should be %{count} character(s)"), do: false
  defp is_custom_error_message?(:length, "should be %{count} byte(s)"), do: false
  defp is_custom_error_message?(:length, "should be %{count} item(s)"), do: false
  defp is_custom_error_message?(:length, "should be at least %{count} character(s)"), do: false
  defp is_custom_error_message?(:length, "should be at least %{count} byte(s)"), do: false
  defp is_custom_error_message?(:length, "should be at least %{count} item(s)"), do: false
  defp is_custom_error_message?(:length, "should be at most %{count} character(s)"), do: false
  defp is_custom_error_message?(:length, "should be at most %{count} byte(s)"), do: false
  defp is_custom_error_message?(:length, "should be at most %{count} item(s)"), do: false
  defp is_custom_error_message?(:number, "must be less than %{number}"), do: false
  defp is_custom_error_message?(:number, "must be greater than %{number}"), do: false
  defp is_custom_error_message?(:number, "must be less than or equal to %{number}"), do: false
  defp is_custom_error_message?(:number, "must be greater than or equal to %{number}"), do: false
  defp is_custom_error_message?(:number, "must be equal to %{number}"), do: false
  defp is_custom_error_message?(:number, "must be not equal to %{number}"), do: false
  defp is_custom_error_message?(:required, "can't be blank"), do: false
  defp is_custom_error_message?(:subset, "has an invalid entry"), do: false
  defp is_custom_error_message?(_, _), do: true
end
