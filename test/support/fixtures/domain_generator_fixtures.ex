defmodule ElixirScribe.Generator.DomainFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirScribe.Generator.Domain` context.
  """

  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainResourceAPI

  @default_args ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
  def domain_contract_fixture(args \\ @default_args) do
    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

    DomainResourceAPI.build_domain_resource_contract!(valid_args, opts)
  end
end
