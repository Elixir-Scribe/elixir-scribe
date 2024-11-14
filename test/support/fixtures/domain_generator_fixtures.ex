defmodule ElixirScribe.Generator.DomainFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.Generator.Domain` context.
  """

  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainResourceAPI

  @default_required_args ["Sales.Catalog", "Product", "products", "name:string", "desc:string"]
  @default_optional_args []

  def domain_contract_fixture(args \\ @default_required_args)

  def domain_contract_fixture(args) when is_map(args) do
    required_args = Map.get(args, :required, @default_required_args)
    optional_args = Map.get(args, :optional, @default_optional_args)
    args = required_args ++ optional_args

    domain_contract_fixture(args)
  end

  def domain_contract_fixture(args) when is_list(args) do
    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

    DomainResourceAPI.build_domain_resource_contract!(valid_args, opts)
  end
end
