defmodule ElixirScribe.Generator.Domain.Resource.GenerateSchema.GenerateSchemaResource do
  @moduledoc false

  alias ElixirScribe.Template.BindingAPI
  alias ElixirScribe.Generator.DomainContract

  def generate(%DomainContract{schema: %{generate?: false}} = contract), do: contract

  def generate(%DomainContract{schema: %{generate?: true}} = contract) do
    schema = ElixirScribe.to_phoenix_schema(contract.schema)
    paths = ElixirScribe.base_template_paths()
    bindings = build_bindings(contract)

    Mix.Tasks.Phx.Gen.Schema.copy_new_files(schema, paths, bindings)

    contract
  end

  defp build_bindings(contract) do
    contract
    |> BindingAPI.build_binding_template()
    |> Keyword.merge(schema: contract.schema)
  end
end
