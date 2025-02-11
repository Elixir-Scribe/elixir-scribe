defmodule ElixirScribe.Generator.SchemaContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.Generator.SchemaResourceAPI
  alias ElixirScribe.Generator.SchemaContract

  test "new!/4 Creates a Resource Schema Contract for a one level Domain" do
    args = ["Blog", "Post", "posts", "title:string", "desc:string"]
    options = [web: "Blog", binary_id: true, schema: true]

    expected_contract = %{
      alias: Post,
      api_route_prefix: "/api/blog/posts",
      assocs: [],
      binary_id: true,
      collection: "posts",
      context_app: :elixir_scribe,
      defaults: %{title: "", desc: ""},
      embedded?: false,
      file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
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
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The default_key it's only used to test the generators created the expected code
      # params: %{
      #   create: %{title: "some title", desc: "some desc"},
      #   default_key: :title,
      #   update: %{title: "some updated title", desc: "some updated desc"}
      # },
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
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The string_attr it's only used to test the generators created the expected code
      # string_attr: :title,
      table: "posts",
      timestamp_type: :naive_datetime,
      types: %{title: :string, desc: :string},
      uniques: [],
      web_namespace: "Blog",
      web_path: "blog"
    }

    expected_attrs = [{:title, :string}, {:desc, :string}]

    expected_fixture_params = [{:desc, "\"some desc\""}, {:title, "\"some title\""}]

    expected_opts = [
      {:web, "Blog"},
      {:schema, true},
      {:binary_id, true}
    ]

    expected_keys = Map.keys(expected_contract)

    assert schema_contract =
             %SchemaContract{} = SchemaResourceAPI.build_schema_resource_contract!(args, options)

    contract = Map.from_struct(schema_contract)
    {attrs, contract} = Map.pop!(contract, :attrs)
    {fixture_params, contract} = Map.pop!(contract, :fixture_params)
    {opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    assert_lists_equal(expected_attrs, attrs)
    assert_lists_equal(expected_fixture_params, fixture_params)
    assert_lists_equal(expected_opts, opts)
  end

  test "new!/4 Creates a Resource Schema Contract for a two level nested Domain" do
    args = ["Blog.Site", "Post", "posts", "title:string", "desc:string"]
    options = [web: "Blog.Site", binary_id: true, schema: true, context: true]

    expected_contract = %{
      alias: Post,
      api_route_prefix: "/api/blog/site/posts",
      assocs: [],
      binary_id: true,
      collection: "posts",
      context_app: :elixir_scribe,
      defaults: %{title: "", desc: ""},
      embedded?: false,
      file: "lib/elixir_scribe/domain/blog/site/post/post_schema.ex",
      fixture_unique_functions: [],
      generate?: true,
      human_plural: "Posts",
      human_singular: "Post",
      indexes: [],
      migration?: true,
      migration_defaults: %{title: "", desc: ""},
      migration_module: Ecto.Migration,
      module: ElixirScribe.Blog.Site.Post,
      optionals: [],
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The default_key it's only used to test the generators created the expected code
      # params: %{
      #   create: %{title: "some title", desc: "some desc"},
      #   default_key: :title,
      #   update: %{title: "some updated title", desc: "some updated desc"}
      # },
      plural: "posts",
      prefix: nil,
      redacts: [],
      repo: ElixirScribe.Repo,
      repo_alias: "",
      route_helper: "blog_site_post",
      route_prefix: "/blog/site/posts",
      sample_id: "11111111-1111-1111-1111-111111111111",
      self: ElixirScribe.Generator.SchemaContract,
      singular: "post",
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The string_attr it's only used to test the generators created the expected code
      # string_attr: :title,
      table: "posts",
      timestamp_type: :naive_datetime,
      types: %{title: :string, desc: :string},
      uniques: [],
      web_namespace: "Blog.Site",
      web_path: "blog/site"
    }

    expected_attrs = [{:title, :string}, {:desc, :string}]

    expected_fixture_params = [{:desc, "\"some desc\""}, {:title, "\"some title\""}]

    expected_opts = [
      {:web, "Blog.Site"},
      {:schema, true},
      {:context, true},
      {:binary_id, true}
    ]

    expected_keys = Map.keys(expected_contract)

    assert schema_contract =
             %SchemaContract{} = SchemaResourceAPI.build_schema_resource_contract!(args, options)

    contract = Map.from_struct(schema_contract)
    {attrs, contract} = Map.pop!(contract, :attrs)
    {fixture_params, contract} = Map.pop!(contract, :fixture_params)
    {opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    assert_lists_equal(expected_attrs, attrs)
    assert_lists_equal(expected_fixture_params, fixture_params)
    assert_lists_equal(expected_opts, opts)
  end

  test "new!/4 Creates a Resource Schema Contract for a three level nested Domain" do
    args = ["Blog.Site.Admin", "Post", "posts", "title:string", "desc:string"]
    options = [web: "Blog.Site.Admin", binary_id: true, schema: true]

    expected_contract = %{
      alias: Post,
      api_route_prefix: "/api/blog/site/admin/posts",
      assocs: [],
      binary_id: true,
      collection: "posts",
      context_app: :elixir_scribe,
      defaults: %{title: "", desc: ""},
      embedded?: false,
      file: "lib/elixir_scribe/domain/blog/site/admin/post/post_schema.ex",
      fixture_unique_functions: [],
      generate?: true,
      human_plural: "Posts",
      human_singular: "Post",
      indexes: [],
      migration?: true,
      migration_defaults: %{title: "", desc: ""},
      migration_module: Ecto.Migration,
      module: ElixirScribe.Blog.Site.Admin.Post,
      optionals: [],
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The default_key it's only used to test the generators created the expected code
      # params: %{
      #   create: %{title: "some title", desc: "some desc"},
      #   default_key: :title,
      #   update: %{title: "some updated title", desc: "some updated desc"}
      # },
      plural: "posts",
      prefix: nil,
      redacts: [],
      repo: ElixirScribe.Repo,
      repo_alias: "",
      route_helper: "blog_site_admin_post",
      route_prefix: "/blog/site/admin/posts",
      sample_id: "11111111-1111-1111-1111-111111111111",
      self: ElixirScribe.Generator.SchemaContract,
      singular: "post",
      # https://github.com/phoenixframework/phoenix/issues/5874#issuecomment-2241190340
      # The string_attr it's only used to test the generators created the expected code
      # string_attr: :title,
      table: "posts",
      timestamp_type: :naive_datetime,
      types: %{title: :string, desc: :string},
      uniques: [],
      web_namespace: "Blog.Site.Admin",
      web_path: "blog/site/admin"
    }

    expected_attrs = [{:title, :string}, {:desc, :string}]

    expected_fixture_params = [{:desc, "\"some desc\""}, {:title, "\"some title\""}]

    expected_opts = [
      {:web, "Blog.Site.Admin"},
      {:schema, true},
      {:binary_id, true}
    ]

    expected_keys = Map.keys(expected_contract)

    assert schema_contract =
             %SchemaContract{} = SchemaResourceAPI.build_schema_resource_contract!(args, options)

    contract = Map.from_struct(schema_contract)
    {attrs, contract} = Map.pop!(contract, :attrs)
    {fixture_params, contract} = Map.pop!(contract, :fixture_params)
    {opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    assert_lists_equal(expected_attrs, attrs)
    assert_lists_equal(expected_fixture_params, fixture_params)
    assert_lists_equal(expected_opts, opts)
  end
end
