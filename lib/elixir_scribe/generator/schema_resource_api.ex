defmodule ElixirScribe.Generator.SchemaResourceAPI do
  @moduledoc false

  alias ElixirScribe.Generator.SchemaContract
  alias ElixirScribe.Generator.Schema.Resource.SchemaResourceHelpers
  alias ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract

  def build_schema_resource_contract(args, opts) when is_list(args) and is_list(opts),
    do: BuildSchemaResourceContract.build(args, opts)

  def build_schema_resource_contract!(args, opts) when is_list(args) and is_list(opts),
    do: BuildSchemaResourceContract.build!(args, opts)

  def default_param_value(%SchemaContract{} = contract, action) when is_atom(action),
    do: SchemaResourceHelpers.default_param(contract, action)

  def live_form_value(%Date{} = date), do: SchemaResourceHelpers.live_form_value(date)
  def live_form_value(%Time{} = time), do: SchemaResourceHelpers.live_form_value(time)
  def live_form_value(%DateTime{} = datetime), do: SchemaResourceHelpers.live_form_value(datetime)

  def live_form_value(%NaiveDateTime{} = naive_datetime),
    do: SchemaResourceHelpers.live_form_value(naive_datetime)

  def live_form_value(value), do: SchemaResourceHelpers.live_form_value(value)
end
