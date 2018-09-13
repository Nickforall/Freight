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
    |> traverse_errors(&traverse_errors_map/1)
    |> build_error_list()
  end

  # https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2
  defp traverse_errors_map({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  # maps key-value map where keys are field names and values are errors to a list
  defp build_error_list(map) do
    Enum.map(map, fn {key, value} ->
      Enum.join([Atom.to_string(key), value], " ")
    end)
  end
end
