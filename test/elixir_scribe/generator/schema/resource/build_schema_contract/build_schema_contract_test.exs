defmodule ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContractTest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.SchemaContract
  alias ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract

  use ElixirScribe.BaseCase, async: true

  describe "doesn't build the Schema contract" do
    test "when is missing some the schema table name for the resource" do
      args = ["Blog.Site.Admin", "Post"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Missing the schema table name for the resource. Needs to be lowercase and in the plural form.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when is missing some the resource name and schema table name" do
      args = ["Blog.Site.Admin"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Missing the resource name and schema table name. Resource name needs to capitalized and the schema name needs to be lowercase and in the plural form.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when is missing all the required args" do
      args = []
      opts = []

      assert_raise RuntimeError, ~r/^No arguments were provided.*$/s, fn ->
        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when the Domain isn't a valid module name" do
      args = ["Blog.Site.admin", "Post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Domain, \"Blog.Site.admin\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource isn't a valid module name" do
      args = ["Blog.Admin", "post", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Expected the Resource, \"post\", to be a valid module name.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Domain and Resource have the same name" do
      args = ["Blog", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^The Domain and Resource should have different name.*$/s,
                   fn ->
                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the Domain and the Application have the same name" do
      args = ["ElixirScribe", "Blog", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Domain ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the Resource and the Application have the same name" do
      args = ["Blog", "ElixirScribe", "posts"]
      opts = []

      assert_raise RuntimeError,
                   ~r/^Cannot generate Resource ElixirScribe because it has the same name as the application.*$/s,
                   fn -> BuildSchemaResourceContract.build!(args, opts) end
    end

    test "when the table name missing from references" do
      assert_raise Mix.Error, ~r/expect the table to be given to user_id:references/, fn ->
        args = ["Blog", "Post", "posts", "user_id:references"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end
    end

    test "when the type missing from array" do
      assert_raise Mix.Error,
                   ~r/expect the type of the array to be given to settings:array/,
                   fn ->
                     args = ["Blog", "Post", "posts", "settings:array"]
                     opts = []

                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the type missing from the enum" do
      assert_raise Mix.Error,
                   ~r/^Enum type requires at least one value/,
                   fn ->
                     args = ["Blog", "Post", "posts", "status:enum"]
                     opts = []

                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when a schema field definition is used in place of the schema table name" do
      assert_raise RuntimeError,
                   ~r/Expected the schema plural argument, \"title:string\", to be all lowercase using snake_case convention.*/,
                   fn ->
                     args = ["Blog", "Post", "title:string"]
                     opts = []

                     BuildSchemaResourceContract.build!(args, opts)
                   end
    end

    test "when the schema plural has uppercased characters or camelized format" do
      assert_raise RuntimeError, fn ->
        args = ["Blog", "Post", "Posts", "title:string"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end

      assert_raise RuntimeError, fn ->
        args = ["Blog", "Post", "BlogPosts", "title:string"]
        opts = []

        BuildSchemaResourceContract.build!(args, opts)
      end
    end
  end

  describe "builds the Schema contract" do
    test "only with required arguments" do
      expected_contract = %{
        route_prefix: "/blog/posts",
        human_singular: "Post",
        web_path: "blog",
        params: %{update: %{}, create: %{}, default_key: :some_field},
        prefix: nil,
        migration?: true,
        sample_id: "11111111-1111-1111-1111-111111111111",
        repo: ElixirScribe.Repo,
        fixture_params: [],
        embedded?: false,
        collection: "posts",
        module: ElixirScribe.Blog.Post,
        uniques: [],
        defaults: %{},
        indexes: [],
        fixture_unique_functions: [],
        redacts: [],
        migration_module: Ecto.Migration,
        alias: Post,
        types: %{},
        self: ElixirScribe.Generator.SchemaContract,
        human_plural: "Posts",
        context_app: :elixir_scribe,
        attrs: [],
        string_attr: nil,
        optionals: [],
        web_namespace: "Blog",
        api_route_prefix: "/api/blog/posts",
        route_helper: "blog_post",
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        generate?: true,
        timestamp_type: :naive_datetime,
        binary_id: true,
        table: "posts",
        singular: "post",
        plural: "posts",
        repo_alias: "",
        assocs: [],
        migration_defaults: %{}
      }

      args = ~w(Blog Post posts)

      assert_schema_contract(args, expected_contract)
    end

    test "with required and optional arguments" do
      expected_contract = %{
        route_prefix: "/blog/posts",
        human_singular: "Post",
        web_path: "blog",
        params: %{
          update: %{title: "some updated title"},
          create: %{title: "some title"},
          default_key: :title
        },
        prefix: nil,
        migration?: true,
        sample_id: "11111111-1111-1111-1111-111111111111",
        repo: ElixirScribe.Repo,
        fixture_params: [title: "\"some title\""],
        embedded?: false,
        collection: "posts",
        module: ElixirScribe.Blog.Post,
        uniques: [],
        defaults: %{title: ""},
        indexes: [],
        fixture_unique_functions: [],
        redacts: [],
        migration_module: Ecto.Migration,
        alias: Post,
        types: %{title: :string},
        self: ElixirScribe.Generator.SchemaContract,
        human_plural: "Posts",
        context_app: :elixir_scribe,
        attrs: [title: :string],
        string_attr: :title,
        optionals: [],
        web_namespace: "Blog",
        api_route_prefix: "/api/blog/posts",
        route_helper: "blog_post",
        file: "lib/elixir_scribe/domain/blog/post/post_schema.ex",
        generate?: true,
        timestamp_type: :naive_datetime,
        binary_id: true,
        table: "posts",
        singular: "post",
        plural: "posts",
        repo_alias: "",
        assocs: [],
        migration_defaults: %{title: ""}
      }

      args = ~w(Blog Post posts title:string)

      assert_schema_contract(args, expected_contract)
    end

    test "with unique indices" do
      args = ~w(Blog Post posts title:unique admin_id:integer:unique)

      expected_contract = %{
        indexes: [
          "create unique_index(:posts, [:admin_id])",
          "create unique_index(:posts, [:title])"
        ],
        fixture_params: [admin_id: "unique_post_admin_id()", title: "unique_post_title()"],
        fixture_unique_functions: [
          admin_id:
            {"unique_post_admin_id",
             "  def unique_post_admin_id, do: System.unique_integer([:positive])\n", false},
          title:
            {"unique_post_title",
             "  def unique_post_title, do: \"some title\#{System.unique_integer([:positive])}\"\n",
             false}
        ]
      }

      assert_schema_contract(args, expected_contract)
    end

    test "with references creates the association and index" do
      expected_contract = %{
        assocs: [{:user, :user_id, "ElixirScribe.Blog.User", :users}],
        indexes: ["create index(:posts, [:user_id])"]
      }

      args = ~w(Blog Post posts title user_id:references:users)

      assert_schema_contract(args, expected_contract)
    end

    test "with uuid type" do
      expected_contract = %{
        types: %{title: :string, slug: Ecto.UUID},
        sample_id: "11111111-1111-1111-1111-111111111111",
        attrs: [title: :string, slug: :uuid]
      }

      args = ~w(Blog Post posts title slug:uuid)

      assert_schema_contract(args, expected_contract)
    end

    test "with proper datetime types" do
      expected_contract = %{
        types: %{
          title: :string,
          drafted_at: :naive_datetime,
          published_at: :naive_datetime,
          edited_at: :utc_datetime,
          locked_at: :naive_datetime_usec,
          deadline_date: :date,
          read_time: :time,
          viewed_at: :utc_datetime_usec,
          write_time: :time_usec
        }
      }

      args =
        ~w(Blog Post posts title:string drafted_at:datetime published_at:naive_datetime edited_at:utc_datetime locked_at:naive_datetime_usec viewed_at:utc_datetime_usec read_time:time write_time:time_usec deadline_date:date)

      assert_schema_contract(args, expected_contract)
    end

    test "with enum type" do
      expected_contract = %{
        types: %{title: :string, status: {:enum, [values: [:unpublished, :published, :deleted]]}},
        attrs: [title: :string, status: {:enum, :"unpublished:published:deleted"}]
      }

      args = ~w(Blog Comment comments title:string status:enum:unpublished:published:deleted)

      assert_schema_contract(args, expected_contract)
    end

    test "with array types" do
      expected_contract = %{
        attrs: [
          {:settings, {:array, :string}},
          {:counts, {:array, :integer}},
          {:averages, {:array, :float}}
        ],
        types: %{
          counts: {:array, :integer},
          settings: {:array, :string},
          averages: {:array, :float}
        }
      }

      args = ~w(Blog Post posts settings:array:string counts:array:integer averages:array:float)

      assert_schema_contract(args, expected_contract)
    end

    test "with map type" do
      expected_contract = %{
        attrs: [tags: :map],
        types: %{tags: :map}
      }

      args = ~w(Blog Post posts tags:map)

      assert_schema_contract(args, expected_contract)
    end

    test "with float type" do
      expected_contract = %{
        attrs: [rating: :float],
        types: %{rating: :float}
      }

      args = ~w(Blog Post posts rating:float)

      assert_schema_contract(args, expected_contract)
    end
  end

  describe "builds the Schema contract with option" do
    test ":table to set a custom database table name" do
      args = ~w(Blog.Post Post posts title:string --table blog_posts)

      assert_schema_contract(args, %{table: "blog_posts"})
    end

    # @TODO Needs to be a SYNC test because of setting an umbrella app
    # test "with option :context_app" do
    #   args = ~w(Blog.Post Post posts title:string --context-app admin)

    #   assert_schema_contract(args, %{context_app: "admin"})
    # end

    test ":prefix to set a custom database prefix" do
      args = ~w(Blog.Post Post posts title:string --prefix admin)

      assert_schema_contract(args, %{prefix: "admin"})
    end

    test ":repo to set a custom repo" do
      args = ~w(Blog.Post Post posts title:string --repo MyApp.CustomRepo)

      assert_schema_contract(args, %{repo: MyApp.CustomRepo})
    end

    test ":migration_dir to set a custom migration dir" do
      args = ~w(Blog.Post Post posts title:string --migration-dir /priv/custom/path)

      assert_schema_contract(args, %{migration_dir: "priv/repo/migrations"})
    end
  end

  defp assert_schema_contract(args, expected_contract) do
    expected_keys = Map.keys(expected_contract)

    # expected_opts = []

    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_schema_cli_command()

    assert {:ok, schema_contract = %SchemaContract{}} =
             BuildSchemaResourceContract.build(valid_args, opts)

    assert ^schema_contract =
             %SchemaContract{} = BuildSchemaResourceContract.build!(valid_args, opts)

    contract = Map.from_struct(schema_contract)

    {_opts, contract} = Map.pop!(contract, :opts)

    assert_maps_equal(expected_contract, contract, expected_keys)
    # assert_lists_equal(expected_opts, opts)
  end
end
