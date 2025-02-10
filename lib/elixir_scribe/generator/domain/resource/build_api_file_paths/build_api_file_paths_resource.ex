defmodule ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResource do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract

  def build(%DomainContract{} = contract), do: build_api_file(contract)

  defp build_api_file(contract) do
    source_path = ElixirScribe.domain_api_template_path() |> Path.join("api_module.ex")
    target_path = contract.api_file

    {:eex, :api, source_path, target_path}
  end
end
