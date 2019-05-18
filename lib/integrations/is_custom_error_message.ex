defmodule Freight.Integrations.Ecto.IsCustomErrorMessage do
  @moduledoc false

  # to be honest, i don't know if this is the best way to see if there are custom errors.
  # however i'm already in too deep now.
  def is_custom_error_message?(:acceptance, "must be accepted"), do: false
  def is_custom_error_message?(:confirmation, "does not match confirmation"), do: false
  def is_custom_error_message?(:exclusion, "is reserved"), do: false
  def is_custom_error_message?(:format, "has invalid format"), do: false
  def is_custom_error_message?(:inclusion, "is invalid"), do: false
  def is_custom_error_message?(:length, "should be %{count} character(s)"), do: false
  def is_custom_error_message?(:length, "should be %{count} byte(s)"), do: false
  def is_custom_error_message?(:length, "should be %{count} item(s)"), do: false
  def is_custom_error_message?(:length, "should be at least %{count} character(s)"), do: false
  def is_custom_error_message?(:length, "should be at least %{count} byte(s)"), do: false
  def is_custom_error_message?(:length, "should be at least %{count} item(s)"), do: false
  def is_custom_error_message?(:length, "should be at most %{count} character(s)"), do: false
  def is_custom_error_message?(:length, "should be at most %{count} byte(s)"), do: false
  def is_custom_error_message?(:length, "should be at most %{count} item(s)"), do: false
  def is_custom_error_message?(:number, "must be less than %{number}"), do: false
  def is_custom_error_message?(:number, "must be greater than %{number}"), do: false
  def is_custom_error_message?(:number, "must be less than or equal to %{number}"), do: false
  def is_custom_error_message?(:number, "must be greater than or equal to %{number}"), do: false
  def is_custom_error_message?(:number, "must be equal to %{number}"), do: false
  def is_custom_error_message?(:number, "must be not equal to %{number}"), do: false
  def is_custom_error_message?(:required, "can't be blank"), do: false
  def is_custom_error_message?(:subset, "has an invalid entry"), do: false
  def is_custom_error_message?(:assoc, "is invalid"), do: false
  def is_custom_error_message?(:embed, "is invalid"), do: false
  def is_custom_error_message?(_, _), do: true
end
