defmodule ElixirScribe.Generator.DomainContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.DomainContract

  setup do
    contract_attrs = %{
      alias: Blog,
      api_file: "lib/elixir_scribe/domain/blog/post_api.ex",
      base_module: ElixirScribe,
      basename: "blog",
      context_app: :elixir_scribe,
      generate?: true,
      lib_domain_dir: "lib/elixir_scribe/domain/blog",
      lib_resource_dir: "lib/elixir_scribe/domain/blog/post",
      lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/posts",
      lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog",
      lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/post",
      lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/posts",
      module: ElixirScribe.Blog,
      name: "Blog",
      opts: [
        {:web, "Blog"},
        {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
        {:schema, true},
        {:context, true},
        {:no_default_actions, false},
        {:actions, nil},
        {:binary_id, true}
      ],
      resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
      resource_module: ElixirScribe.Blog.Post,
      resource_module_plural: ElixirScribe.Blog.Posts,
      resource_path_name_plural: "posts",
      resource_path_name_singular: "post",
      schema: %ElixirScribe.Generator.SchemaContract{
        alias: Post,
        api_route_prefix: "/api/blog/posts",
        assocs: [],
        attrs: [{:title, :string}, {:desc, :string}],
        binary_id: true,
        collection: "posts",
        context_app: :elixir_scribe,
        defaults: %{title: "", desc: ""},
        embedded?: false,
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        fixture_params: [{:desc, "\"some desc\""}, {:title, "\"some title\""}],
        fixture_unique_functions: [],
        generate?: true,
        human_plural: "Posts",
        human_singular: "Post",
        indexes: [],
        migration?: true,
        migration_defaults: %{title: "", desc: ""},
        migration_module: Ecto.Migration,
        module: ElixirScribe.Blog.Post,
        optionals: [],
        opts: [
          {:web, "Blog"},
          {:resource_actions, ["list", "new", "read", "edit", "create", "update", "delete"]},
          {:schema, true},
          {:context, true},
          {:no_default_actions, false},
          {:actions, nil},
          {:binary_id, true}
        ],
        params: %{
          create: %{title: "some title", desc: "some desc"},
          default_key: :title,
          update: %{title: "some updated title", desc: "some updated desc"}
        },
        plural: "posts",
        prefix: nil,
        redacts: [],
        repo: ElixirScribe.Repo,
        repo_alias: "",
        route_helper: "blog_post",
        route_prefix: "/blog/posts",
        sample_id: "11111111-1111-1111-1111-111111111111",
        self: ElixirScribe.Generator.SchemaContract,
        singular: "post",
        string_attr: :title,
        table: "posts",
        timestamp_type: :naive_datetime,
        types: %{title: :string, desc: :string},
        uniques: [],
        web_namespace: "Blog",
        web_path: "blog"
      },
      self: ElixirScribe.Generator.DomainContract,
      test_domain_dir: "test/elixir_scribe/domain/blog",
      test_file: "test/elixir_scribe/domain/blog_test.exs",
      test_fixtures_file: "test/support/fixtures/domain/blog/post_fixtures.ex",
      test_resource_dir: "test/elixir_scribe/domain/blog/post",
      test_resource_dir_plural: "test/elixir_scribe/domain/blog/posts",
      test_web_domain_dir: "test/elixir_scribe_web/domain/blog",
      test_web_resource_dir: "test/elixir_scribe_web/domain/blog/post",
      test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/posts",
      web_domain_module: ElixirScribeWeb.Blog,
      web_module: ElixirScribeWeb,
      web_resource_module: ElixirScribeWeb.Blog.Post,
      web_resource_module_plural: ElixirScribeWeb.Blog.Posts
    }

    %{contract_attrs: contract_attrs}
  end

  describe "Builds the contract successfully with" do
    test "new/1", %{contract_attrs: contract_attrs} do
      assert {:ok, domain_contract = %DomainContract{}} = DomainContract.new(contract_attrs)

      expected_fields = Map.keys(contract_attrs)

      assert_maps_equal(contract_attrs, domain_contract, expected_fields)
    end

    test "new!/1", %{contract_attrs: contract_attrs} do
      assert domain_contract = %DomainContract{} = DomainContract.new!(contract_attrs)

      expected_fields = Map.keys(contract_attrs)

      assert_maps_equal(contract_attrs, domain_contract, expected_fields)
    end
  end

  describe "When it fails to build the contract" do
    test "new/1 returns an :error tuple" do
      assert {:error, _reason} = DomainContract.new(%{})
    end

    test "new!/1 raises" do
      assert_raise Norm.MismatchError,
                   ~r/^Could not conform input:.*$/s,
                   fn -> DomainContract.new!(%{}) end
    end
  end
end
