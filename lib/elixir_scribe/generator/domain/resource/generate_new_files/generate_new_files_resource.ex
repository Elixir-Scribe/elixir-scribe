defmodule ElixirScribe.Generator.Domain.Resource.GenerateNewFiles.GenerateNewFilesResource do
  @moduledoc false

  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.DomainResourceAPI

  def generate(%DomainContract{} = contract, opts) when is_list(opts) do
    prompt_for_conflicts? = Keyword.get(opts, :prompt_for_conflicts?, true)

    if prompt_for_conflicts? do
      prompt_for_conflicts(contract)
    end

    contract
    |> DomainResourceAPI.generate_api()
    |> DomainResourceAPI.generate_schema()
    |> DomainResourceAPI.generate_actions()
    |> DomainResourceAPI.generate_tests()
    |> DomainResourceAPI.generate_test_fixture()

    contract
  end

  defp prompt_for_conflicts(contract) do
    contract
    |> DomainResourceAPI.build_files_to_generate()
    |> MixAPI.prompt_for_file_conflicts()
  end
end
