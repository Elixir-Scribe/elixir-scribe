defmodule ElixirScribe.Generator.Domain.Resource.BuildFilesToGenerate.BuildFilesToGenerateResource do
  @moduledoc false

  alias ElixirScribe.Generator.DomainResourceAPI
  alias ElixirScribe.Generator.DomainContract

  @doc false
  def build(%DomainContract{} = contract), do: build_files(contract)

  def build_files(contract) do
    api_file = [DomainResourceAPI.build_api_file_paths(contract)]
    resource_files = DomainResourceAPI.build_action_files_paths(contract)
    resource_test_files = DomainResourceAPI.build_test_action_files_paths(contract)
    schema = ElixirScribe.to_phoenix_schema(contract.schema)
    schema_files = Mix.Tasks.Phx.Gen.Schema.files_to_be_generated(schema)
    test_fixtures_file = build_test_fixture_file(contract)

    api_file
    |> Kernel.++(resource_files)
    |> Kernel.++(resource_test_files)
    |> Kernel.++(schema_files)
    |> Kernel.++(test_fixtures_file)
  end

  defp build_test_fixture_file(%DomainContract{test_fixtures_file: test_fixtures_file}) do
    source_path = ElixirScribe.domain_tests_template_path() |> Path.join("fixtures_module.ex")

    [{:eex, source_path, test_fixtures_file}]
  end
end
