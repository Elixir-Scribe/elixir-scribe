defmodule ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContractTest do
  use ElixirScribe.BaseCase, async: true

  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.Domain.Resource.BuildContract.BuildDomainResourceContract
  alias ElixirScribe.Generator.DomainContract

  defp assert_contract([domain | _] = args, expected_contract) do
    expected_keys = Map.keys(expected_contract)

    expected_resource_actions = ["list", "new", "read", "edit", "create", "update", "delete"]

    expected_opts = [
      {:web, domain},
      {:resource_actions, expected_resource_actions},
      {:schema, true},
      {:no_default_actions, false},
      {:actions, nil},
      {:html_template, "default"}
    ]

    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

    assert {:ok, domain_contract = %DomainContract{}} =
             BuildDomainResourceContract.build(valid_args, opts)

    assert ^domain_contract =
             %DomainContract{} = BuildDomainResourceContract.build!(valid_args, opts)

    contract = Map.from_struct(domain_contract)
    {resource_actions, contract} = Map.pop!(contract, :resource_actions)
    {opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    assert_lists_equal(expected_resource_actions, resource_actions)
    assert_lists_equal(expected_opts, opts)
  end

  describe "builds the contract successfully" do
    test "with one Domain" do
      args = ["Blog", "Post", "posts", "title:string", "desc:string"]

      expected_contract = %{
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
        resource_module: ElixirScribe.Blog.Post,
        resource_module_plural: ElixirScribe.Blog.Posts,
        resource_path_name_plural: "posts",
        resource_path_name_singular: "post",
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

      assert_contract(args, expected_contract)
    end

    test "with two nested Domains" do
      args = ["Blog.Site", "Post", "posts", "title:string", "desc:string"]

      expected_contract = %{
        alias: Site,
        api_file: "lib/elixir_scribe/domain/blog/site/post_api.ex",
        base_module: ElixirScribe,
        basename: "site",
        context_app: :elixir_scribe,
        generate?: true,
        lib_domain_dir: "lib/elixir_scribe/domain/blog/site",
        lib_resource_dir: "lib/elixir_scribe/domain/blog/site/post",
        lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/site/posts",
        lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog/site",
        lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/site/post",
        lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/site/posts",
        module: ElixirScribe.Blog.Site,
        name: "Blog.Site",
        resource_module: ElixirScribe.Blog.Site.Post,
        resource_module_plural: ElixirScribe.Blog.Site.Posts,
        resource_path_name_plural: "posts",
        resource_path_name_singular: "post",
        self: ElixirScribe.Generator.DomainContract,
        test_domain_dir: "test/elixir_scribe/domain/blog/site",
        test_file: "test/elixir_scribe/domain/blog/site_test.exs",
        test_fixtures_file: "test/support/fixtures/domain/blog/site/post_fixtures.ex",
        test_resource_dir: "test/elixir_scribe/domain/blog/site/post",
        test_resource_dir_plural: "test/elixir_scribe/domain/blog/site/posts",
        test_web_domain_dir: "test/elixir_scribe_web/domain/blog/site",
        test_web_resource_dir: "test/elixir_scribe_web/domain/blog/site/post",
        test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/site/posts",
        web_domain_module: ElixirScribeWeb.Blog.Site,
        web_module: ElixirScribeWeb,
        web_resource_module: ElixirScribeWeb.Blog.Site.Post,
        web_resource_module_plural: ElixirScribeWeb.Blog.Site.Posts
      }

      assert_contract(args, expected_contract)
    end

    test "with three nested Domains" do
      args = ["Blog.Site.Admin", "Post", "posts", "title:string", "desc:string"]

      expected_contract = %{
        alias: Admin,
        api_file: "lib/elixir_scribe/domain/blog/site/admin/post_api.ex",
        base_module: ElixirScribe,
        basename: "admin",
        context_app: :elixir_scribe,
        generate?: true,
        lib_domain_dir: "lib/elixir_scribe/domain/blog/site/admin",
        lib_resource_dir: "lib/elixir_scribe/domain/blog/site/admin/post",
        lib_resource_dir_plural: "lib/elixir_scribe/domain/blog/site/admin/posts",
        lib_web_domain_dir: "lib/elixir_scribe_web/domain/blog/site/admin",
        lib_web_resource_dir: "lib/elixir_scribe_web/domain/blog/site/admin/post",
        lib_web_resource_dir_plural: "lib/elixir_scribe_web/domain/blog/site/admin/posts",
        module: ElixirScribe.Blog.Site.Admin,
        name: "Blog.Site.Admin",
        resource_module: ElixirScribe.Blog.Site.Admin.Post,
        resource_module_plural: ElixirScribe.Blog.Site.Admin.Posts,
        resource_path_name_plural: "posts",
        resource_path_name_singular: "post",
        self: ElixirScribe.Generator.DomainContract,
        test_domain_dir: "test/elixir_scribe/domain/blog/site/admin",
        test_file: "test/elixir_scribe/domain/blog/site/admin_test.exs",
        test_fixtures_file: "test/support/fixtures/domain/blog/site/admin/post_fixtures.ex",
        test_resource_dir: "test/elixir_scribe/domain/blog/site/admin/post",
        test_resource_dir_plural: "test/elixir_scribe/domain/blog/site/admin/posts",
        test_web_domain_dir: "test/elixir_scribe_web/domain/blog/site/admin",
        test_web_resource_dir: "test/elixir_scribe_web/domain/blog/site/admin/post",
        test_web_resource_dir_plural: "test/elixir_scribe_web/domain/blog/site/admin/posts",
        web_domain_module: ElixirScribeWeb.Blog.Site.Admin,
        web_module: ElixirScribeWeb,
        web_resource_module: ElixirScribeWeb.Blog.Site.Admin.Post,
        web_resource_module_plural: ElixirScribeWeb.Blog.Site.Admin.Posts
      }

      assert_contract(args, expected_contract)
    end
  end

  describe "doesn't build the contract" do
    test "when is missing some of the required args" do
      args = ["Blog.Site.Admin", "Post"]
      opts = []

      assert_raise RuntimeError, ~r/^Not enough arguments.*$/s, fn ->
        BuildDomainResourceContract.build!(args, opts)
      end
    end

    test "when is missing all the required args" do
      args = []
      opts = []

      assert_raise RuntimeError, ~r/^No arguments were provided.*$/s, fn ->
        BuildDomainResourceContract.build!(args, opts)
      end
    end

    test "when the Domain isn't a valid module name" do
      args = ["Blog.Site.admin", "Post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Domain, \"Blog.Site.admin\", to be a valid module name.*$/s,
                   fn -> BuildDomainResourceContract.build!(args, opts) end
    end

    test "when the Resource isn't a valid module name" do
      args = ["Blog.Admin", "post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Resource, \"post\", to be a valid module name.*$/s,
                   fn -> BuildDomainResourceContract.build!(args, opts) end
    end

    test "when the Domain and Resource have the same name" do
      args = ["Blog", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^The Domain and Resource should have different name.*$/s,
                   fn ->
                     BuildDomainResourceContract.build!(args, opts)
                   end
    end

    test "when the Domain and the Application have the same name" do
      args = ["ElixirScribe", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Domain ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildDomainResourceContract.build!(args, opts) end
    end

    test "when the Resource and the Application have the same name" do
      args = ["Blog", "ElixirScribe", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Resource ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildDomainResourceContract.build!(args, opts) end
    end
  end
end
