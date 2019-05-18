defmodule Freight do
  @doc """
  Gets an atom that is the name of the error object as used in payloads from the Application environment
  """
  def error_object do
    Application.get_env(:freight, :error_object, nil)
  end

  @doc """
  Gets a boolean defining whether Freight should lower camelize field names prepended on errors, as by Absinthe convention
  """
  def lower_camelize_field_name? do
    Application.get_env(:freight, :lower_camelize_field_name, false)
  end
end
