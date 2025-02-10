defmodule ElixirScribe do
  @moduledoc """
  The Elixir Scribe Generator configuration and defaults.

  All functions in this Module **MUST** be considered private and only used internally.

  Some of the defaults will be possible to customize via your app configuration.


  ## Defaults

  ### Templates Paths

  The paths to look for template files for generators defaults to checking the current app's `priv` directory, and falls back to Elixir Scribe and Phoenix's `priv` directory:

  * `priv/templates/*`
  * `elixir_scribe/priv/templates/*`
  * `phoenix/priv/templates/*`

  ### Default Actions

  The default actions supported by `scribe.gen.domain` and `scribe.gen.html`:

  * `list` - Lists all items of a Resource in the database
  * `new` - Builds a new changeset for a Resource
  * `read` - Reads a specific Resource from the database
  * `edit` - Builds a changeset to track changes made to a Resource
  * `create` - Creates a new Resource in the database
  * `update` - Updates an existing Resource
  * `delete` - Deletes an existing Resource


  ## Configuration

  In your app configuration you can:

  * [Configure Default Actions](#module-configure-default-actions) - Provide your own list of built-in default actions that will be used each time you invoke one of the generators.
  * [Configure Default Actions Aliases](#module-configure-default-actions-aliases) - Use aliases to rename the built-in default actions to your preferred names.
  * [Configure Custom Default Actions](#module-configure-custom-default-actions) - Provide your own custom action names, that wil use the default template or one provided by your app.

  ### Configure Default Actions

  > #### Custom Default Actions {: .info}
  > Any custom action name provided via the configuration will be mapped to a default template, unless you provide your custom template(s) for it at the correct path in your app `priv/templates/*`.
  >
  > This custom action names will be added to your router as `GET` requests. You need to customize the router as needed.

  > #### Default Actions Order {: .error}
  > Order of actions **MATTERS**, otherwise routes will not work as expected.


  For example, for an API you can  discard the default actions `new` and `edit`:

  ```elixir
  config :elixir_scribe,
    default_actions: ["list", "read", "create", "update", "delete"]
  ```

  Or, maybe you want to use the default actions, plus some other ones that you always need when creating a new resource:

  ```elixir
  config :elixir_scribe,
    default_actions: ["import", "export", "list", "new", "read", "edit", "create", "update", "delete"]
  ```

  Note how `import` and `export` were added to the begin of the list to ensure they are matched correctly by the router when serving the `GET` request.

  ### Configure Default Actions Aliases

  In your app configuration for `:elixir_scribe` you can map any of the built-in default actions to actions names of your preference, which it's the same as renaming them.

  The below example maps the built-in default actions `read` to `show` and `list` to `index`.

  ```elixir
  config :elixir_scribe,
    resource_actions_aliases: %{
        "read" => "show",
        "list" => "index",
      }
  ```

  ### Configure Custom Default Actions

  When using custom actions the generators can be configured to use your own templates for code generation instead of falling back to a default template.

  """

  @doc false
  def base_template_paths(), do: [".", :elixir_scribe, :phoenix]

  @doc false
  def app_name() do
    Mix.Project.config() |> Keyword.get(:app) |> Atom.to_string()
  end

  @doc false
  def app_path(:lib_core), do: Path.join(["lib", app_name()])

  @doc false
  def app_path(:test_core), do: Path.join(["test", app_name()])

  @doc false
  def app_path(:lib_web), do: app_path(:lib_core) <> "_web"

  @doc false
  def app_path(:test_web), do: app_path(:test_core) <> "_web"

  @web_template_path "priv/templates/scribe.gen.html"
  @doc false
  def web_template_path(), do: @web_template_path

  @html_template_path @web_template_path |> Path.join("html")
  @doc false
  def html_template_path(), do: @html_template_path

  @controller_template_path @web_template_path |> Path.join("controllers")
  @doc false
  def controller_template_path(), do: @controller_template_path

  @controller_test_template_path Path.join([@web_template_path, "tests", "controllers"])
  @doc false
  def controller_test_template_path(), do: @controller_test_template_path

  @domain_template_path "priv/templates/scribe.gen.domain"
  @doc false
  def domain_template_path(), do: @domain_template_path

  @domain_tests_template_path @domain_template_path |> Path.join("tests")
  @doc false
  def domain_tests_template_path(), do: @domain_tests_template_path

  @domain_api_template_path @domain_template_path |> Path.join("apis")
  @doc false
  def domain_api_template_path(), do: @domain_api_template_path

  @resource_actions_template_path @domain_template_path |> Path.join("actions")
  @doc false
  def resource_actions_template_path(), do: @resource_actions_template_path

  @resource_test_actions_template_path @domain_tests_template_path |> Path.join("actions")
  @doc false
  def resource_test_actions_template_path(), do: @resource_test_actions_template_path

  # @IMPORTANT: Order of actions MATTERS, otherwise routes will not work as
  #  expected. Don't allow override from config, but allow to set aliases.
  @actions ["list", "new", "read", "edit", "create", "update", "delete"]
  @doc false
  def resource_actions(), do: @actions

  @doc false
  def resource_actions_aliases() do
    # @TODO Get from configuration.

    %{
      # "default_action" => "alias"
    }
  end

  @doc false
  def resource_action_alias(action) do
    resource_actions_aliases() |> Map.get(action, action)
  end

  @resource_html_actions ["read", "new", "edit", "list"]
  @doc false
  def resource_html_actions(), do: @resource_html_actions

  @doc false
  def resource_plural_actions() do
    # @TODO Allow to override from configuration
    ["index", "list"]
  end

  @doc false
  def schema_template_folder_name(%ElixirScribe.Generator.SchemaContract{} = schema) do
    if schema.generate? do
      "schema_access"
    else
      "no_schema_access"
    end
  end

  @app_file_extensions [".ex", ".exs", "html.heex"]
  @doc false
  def app_file_extensions(), do: @app_file_extensions

  @app_file_types ["", "controller", "controller_test", "test"]
  @doc false
  def app_file_types(), do: @app_file_types

  @app_path_types [:lib_core, :lib_web, :test_core, :test_web]
  @doc false
  def app_path_types(), do: @app_path_types

  # @TODO Remove once `mix phx.gem.schema` is ported to `mix scribe.gen.schema`.
  @doc false
  def to_phoenix_schema(%ElixirScribe.Generator.SchemaContract{} = schema) do
    attrs = Map.from_struct(schema)
    struct(Mix.Phoenix.Schema, attrs)
  end
end
