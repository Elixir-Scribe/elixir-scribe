defmodule ElixirScribe.Generator.Domain.Resource.BuildFilesToGenerate.BuildFilesToGenerateResourceTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.DomainResourceAPI

  test "files_to_generate/1 works as expected" do
    expected_files = [
      {:eex, :api, "priv/templates/scribe.gen.domain/apis/api_module.ex",
       "lib/elixir_scribe/domain/site/blog/post_api.ex"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/list_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/list/list_posts.ex", "list"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/new_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/new/new_post.ex", "new"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/read_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/read/read_post.ex", "read"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/edit_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/edit/edit_post.ex", "edit"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/create_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/create/create_post.ex", "create"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/update_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/update/update_post.ex", "update"},
      {:eex, :resource, "priv/templates/scribe.gen.domain/actions/schema_access/delete_schema.ex",
       "lib/elixir_scribe/domain/site/blog/post/delete/delete_post.ex", "delete"},
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
       "test/elixir_scribe/domain/site/blog/post/delete/delete_post_test.exs", "delete"},
      {:eex, "schema.ex", "lib/elixir_scribe/domain/site/blog/post/post_schema.ex"},
      {:eex, "priv/templates/scribe.gen.domain/tests/fixtures_module.ex",
       "test/support/fixtures/domain/site/blog/post_fixtures.ex"}
    ]

    domain_contract = domain_contract_fixture()

    assert DomainResourceAPI.build_files_to_generate(domain_contract) === expected_files
  end
end
