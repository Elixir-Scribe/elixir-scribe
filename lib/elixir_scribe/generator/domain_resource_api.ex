defmodule ElixirScribe.Generator.DomainResourceAPI do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.Resource.GenerateSchema.GenerateSchemaResource
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContract
  alias ElixirScribe.Generator.Domain.Resource.BuildFilesToGenerate.BuildFilesToGenerateResource
  alias ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateActions.GenerateActionsResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateTests.GenerateTestsResource
  alias ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource

  alias ElixirScribe.Generator.Domain.Resource.BuildTestActionFilesPaths.BuildTestActionFilesPathsResource

  alias ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResource
  alias ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource

  @doc """
  Resource: Build DomainContract.
  """
  def build_domain_resource_contract(args, opts) when is_list(args) and is_list(opts),
    do: BuildDomainResourceContract.build(args, opts)

  def build_domain_resource_contract!(args, opts) when is_list(args) and is_list(opts),
    do: BuildDomainResourceContract.build!(args, opts)

  @doc """
  Resource: Files To Generate.
  """
  def build_files_to_generate(%DomainContract{} = contract),
    do: BuildFilesToGenerateResource.build(contract)

  @doc """
  Resource: Build Action Files To Generate
  """
  def build_action_files_paths(%DomainContract{} = contract),
    do: BuildActionFilesPathsResource.build(contract)

  @doc """
  Resource: Build Test Action Files To Generate
  """
  def build_test_action_files_paths(%DomainContract{} = contract),
    do: BuildTestActionFilesPathsResource.build(contract)

  def build_api_file_paths(%DomainContract{} = contract),
    do: BuildAPIFilePathsResource.build(contract)

  @doc """
  Resource: Generate Schema.
  """
  def generate_schema(%DomainContract{} = contract),
    do: GenerateSchemaResource.generate(contract)

  @doc """
  Resource: Generate Actions.
  """
  def generate_actions(%DomainContract{} = contract),
    do: GenerateActionsResource.generate(contract)

  @doc """
  Resource: Generate Tests.
  """
  def generate_tests(%DomainContract{} = contract),
    do: GenerateTestsResource.generate(contract)

  @doc """
  Resource: Generate Api.
  """
  def generate_api(%DomainContract{} = contract), do: GenerateApiResource.generate(contract)

  @doc """
  Resource: Generate Test Fixture.
  """
  def generate_test_fixture(%DomainContract{} = contract),
    do: GenerateTestFixtureResource.generate(contract)

  @doc """
  Resource: Generate New Files.
  """
  def generate_new_files(%DomainContract{} = contract, opts \\ []) when is_list(opts),
    do: GenerateNewFilesResource.generate(contract, opts)
end
