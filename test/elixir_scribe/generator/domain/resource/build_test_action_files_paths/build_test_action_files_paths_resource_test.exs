defmodule ElixirScribe.Generator.Domain.Resource.BuildTestActionFilesPaths.BuildTestActionFilesPathsResourceTest do
  alias ElixirScribe.Generator.DomainResourceAPI

  use ElixirScribe.BaseCase, async: true

  test "returns a list of all resource action test files paths" do
    expected_files = [
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/list_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/list/list_posts_test.exs", "list"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/new_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/new/new_post_test.exs", "new"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/read_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/read/read_post_test.exs", "read"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/edit_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/edit/edit_post_test.exs", "edit"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/create_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/create/create_post_test.exs", "create"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/update_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/update/update_post_test.exs", "update"},
      {:eex, :resource_test,
       "priv/templates/scribe.gen.domain/tests/actions/schema_access/delete_schema_test.exs",
       "test/elixir_scribe/domain/site/blog/post/delete/delete_post_test.exs", "delete"}
    ]

    contract = domain_contract_fixture()

    assert DomainResourceAPI.build_test_action_files_paths(contract) === expected_files
  end
end
