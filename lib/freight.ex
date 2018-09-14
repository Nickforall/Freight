defmodule Freight do
  @doc """
  Gets an atom that is the name of the error object as used in payloads from the Application environment
  """
  def error_object do
    Application.get_env(:freight, :error_object, nil)
  end
end
