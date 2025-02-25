defmodule ElixirScribe.Generator.Schema.Resource.SchemaResourceHelpers do
  @moduledoc false

  alias ElixirScribe.Generator.SchemaContract

  @valid_types [
    :integer,
    :float,
    :decimal,
    :boolean,
    :map,
    :string,
    :array,
    :references,
    :text,
    :date,
    :time,
    :time_usec,
    :naive_datetime,
    :naive_datetime_usec,
    :utc_datetime,
    :utc_datetime_usec,
    :uuid,
    :binary,
    :enum
  ]

  def valid_types, do: @valid_types

  @doc """
  Returns the string value of the default schema param.
  """
  def default_param(%SchemaContract{} = schema, action) when is_atom(action) do
    schema.params
    |> Map.fetch!(action)
    |> Map.fetch!(schema.params.default_key)
    |> to_string()
  end

  @doc """
  Converts the given value to map format when it is a date, time, datetime or naive_datetime.

  Since `form_component.html.heex` generated by the live generator uses selects for dates and/or
  times, fixtures must use map format for those fields in order to submit the live form.
  """
  def live_form_value(%Date{} = date), do: Calendar.strftime(date, "%Y-%m-%d")

  def live_form_value(%Time{} = time), do: Calendar.strftime(time, "%H:%M")

  def live_form_value(%NaiveDateTime{} = naive) do
    NaiveDateTime.to_iso8601(naive)
  end

  def live_form_value(%DateTime{} = naive) do
    DateTime.to_iso8601(naive)
  end

  def live_form_value(value), do: value

  @doc """
  Build an invalid value for `@invalid_attrs` which is nil by default.

  * In case the value is a list, this will return an empty array.
  * In case the value is date, datetime, naive_datetime or time, this will return an invalid date.
  * In case it is a boolean, we keep it as false
  """
  def invalid_form_value(value) when is_list(value), do: []

  def invalid_form_value(%{day: _day, month: _month, year: _year} = _date),
    do: "2022-00"

  def invalid_form_value(%{hour: _hour, minute: _minute}), do: %{hour: 14, minute: 00}
  def invalid_form_value(true), do: false
  def invalid_form_value(_value), do: nil

  @doc """
  Generates an invalid error message according to the params present in the schema.
  """
  def failed_render_change_message(_schema) do
    "can&#39;t be blank"
  end

  def type_for_migration({:enum, _}), do: :string
  def type_for_migration(other), do: other

  def format_fields_for_schema(schema) do
    Enum.map_join(schema.types, "\n", fn {k, v} ->
      "    field #{inspect(k)}, #{type_and_opts_for_schema(v)}#{schema.defaults[k]}#{maybe_redact_field(k in schema.redacts)}"
    end)
  end

  @doc """
  Return the required fields in the schema. Anything not in the `optionals` list
  is considered required.
  """
  def required_fields(schema) do
    Enum.reject(schema.attrs, fn {key, _} -> key in schema.optionals end)
  end

  def type_and_opts_for_schema({:enum, opts}),
    do: ~s|Ecto.Enum, values: #{inspect(Keyword.get(opts, :values))}|

  def type_and_opts_for_schema(other), do: inspect(other)

  def maybe_redact_field(true), do: ", redact: true"
  def maybe_redact_field(false), do: ""

  @doc """
  Returns the string value for use in EEx templates.
  """
  def value(schema, field, value) do
    schema.types
    |> Map.fetch!(field)
    |> inspect_value(value)
  end

  defp inspect_value(:decimal, value), do: "Decimal.new(\"#{value}\")"
  defp inspect_value(_type, value), do: inspect(value)
end
