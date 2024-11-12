defmodule ElixirScribe.Generator.Domain.Resource.BuildAPIFilePaths.BuildAPIFilePathsResourceTest do
  alias ElixirScribe.Generator.DomainResourceAPI
  use ElixirScribe.BaseCase, async: true

  test "returns the API file paths" do
    expected_files =
      {:eex, :api, "priv/templates/scribe.gen.domain/apis/api_module.ex",
       "lib/elixir_scribe/domain/site/blog/post_api.ex"}

    contract = domain_contract_fixture()

    assert DomainResourceAPI.build_api_file_paths(contract) === expected_files
  end
end
