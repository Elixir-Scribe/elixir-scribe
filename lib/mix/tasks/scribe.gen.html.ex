defmodule Mix.Tasks.Scribe.Gen.Html do
  # This module was borrowed from the Phoenix Framework module
  # Mix.Tasks.Phx.Gen.Html and modified to suite ElixirScribe needs.

  @shortdoc "Generates the domain and controller for an HTML resource"

  @moduledoc """
  Generates a module per action for a resource within a domain at `lib/my_app_web/*` and `lib/my_app/*`, with the related tests. This includes the controller, view, templates, the schema, the module for resource action with functions around an Ecto schema and the Resource API boundary module.

  The goal and motivation is to encourage developers to write cleaner code in a more organized folder structure, enabling them to know in seconds all domains, resources, and actions used in a project. This  also contributes to reduce the technical debt via less complexity and clear boundaries between domains, resources and actions.

  ## Usage Examples

  The `scribe.gen.html` generator will generate files in both `lib/my_app_web/*`, `lib/my_app/*` and `tests/*` folders with the same hierarchy structure.

  For example, to create a fictitious online shop app you may start with this command:

  ```
  mix scribe.gen.html Catalog Category categories name:string desc:string
  ```

  The first argument is the domain name followed by the resource name and its plural name, which is also used as the schema table name. The second argument, `Catalog`, is the resource's schema. A schema is an Elixir module responsible for mapping database fields into an Elixir struct. The `Catalog` schema above specifies two fields with their respective colon-delimited data types: `name:string` and `desc:string`. See `mix phx.gen.schema` for more information on attributes.

  By default the command will generate some default actions for each resource on
  a domain: `["list", "new", "read", "edit", "create", "update", "delete"]`.

  We can also pass as many custom actions as we want with the flag `--actions`:

  ```
  mix scribe.gen.html Catalog Product products name:string desc:string --actions import,export
  ```

  When don't need to use the default actions, then just pass the flag `--no-default-actions`:

  ```
  mix scribe.gen.html Warehouse Stock stocks product_id:integer quantity:integer --actions import,export --no-default-actions
  ```

  ### The folder structure

  By using the previous command examples we get this folder structure:

  ```text
  $ tree -d -L 4 lib/my_app_web

  lib/my_app_web
  ├── components
  │   └── layouts
  ├── controllers
  │   └── page_html
  └── domains
      ├── catalog
      │   ├── category
      │   │   ├── create
      │   │   ├── delete
      │   │   ├── edit
      │   │   ├── export
      │   │   ├── import
      │   │   ├── list
      │   │   ├── new
      │   │   ├── read
      │   │   └── update
      │   └── product
      │       ├── create
      │       ├── delete
      │       ├── edit
      │       ├── export
      │       ├── import
      │       ├── list
      │       ├── new
      │       ├── read
      │       └── update
      └── warehouse
          └── stock
              ├── edit
              ├── export
              ├── import
              ├── list
              ├── new
              └── read

  ```

  This generator adds the following files to `lib/`:

    * a controller per resource action at `lib/my_app_web/domains/domain/resource/action`.
    * default HTML templates per resource action in `lib/my_app_web/domains/domain/resource/action`.
    * an HTML view per resource in `lib/my_app_web/domains/domain/resource`.
    * a schema per resource in `lib/my_app/domains/domain/resource`.
    * a module per resource action in `lib/my_app/domains/domain/resource/action`
    * a resource API boundary module in `lib/my_app/domains/domain`.

  Additionally, this generator creates the following files:

    * a migration for the schema in `priv/repo/migrations`.
    * a controller test module per resource action in `test/my_app_web/domains/domain/resource/action`.
    * a a module per resource action in `test/my_app/domains/domain/resource/action`.
    * a context test helper module in `test/support/fixtures/[resource_name]_fixtures.ex`.


  ## The API Boundary

  To prevent direct access between resources of the same domain or cross domains
  an API is provided for each Resource to act as a boundary that MUST never be
  crossed to not couple domains and resources via the internal implementation.

  This enables developers to change the internal implementation of any action of
  a Resource knowing that the only caller is the resource API boundary.

  The API boundary for each resource in a domain is located at the root of the
  domain folder. For example: `MyApp.Catalog.CategoryAPI`, which can be
  found at `lib/my_app/catalog/category_api.ex`.

  Developers need to treat anything inside a resource as private, which for the
  Catalog domain (exemplified above) means to not access any module inside
  `lib/my_app/catalog/category/*`.


  ## The Schema

  The schema is responsible for mapping the database fields into an
  Elixir struct. A migration file for the repository will also be generated.

  The schema can be found at `lib/my_app/catalog/category_schema.ex` and it's
  considered private, except for it's struct representation. To work with changesets you want to use the Domain API, and only used this module directly to pattern match on it's struct. For example, instead of using `Category.changeset/2` to create a new changeset, use "CategoryAPI.new/1".

  ### Generating without a schema

  In some cases, you may wish to bootstrap the domain and its resources without
  any logic to access the schema, leaving the internal implementation to
  yourself. Use the `--no-schema` flag to accomplish this.

  For example:

  ```
  mix scribe.gen.html Accounts Company companies --no-schema
  ```

  ## The Database Table

  By default, the table name for the migration and schema will be
  the plural name provided for the resource. To customize this value,
  a `--table` option may be provided.

  For example:

  ```
  mix scribe.gen.html Accounts User users --table cms_users
  ```

  ## Binary ID by Default

  By default the generated migration uses `binary_id` for schema's primary key
  and its references. To not use it you may pass the flag `--no-binary-id`.

  For example:

  ```
  mix scribe.gen.html Accounts AdminUser admin_users --no-binary-id
  ```

  >### Security Implications of `--no-binary-id` {: .warning}
  >* For security reasons is **strongly** discouraged the use of
  >  regular numeric ids.
  >* Numeric IDs allows an attacker to easily enumerate all resources by
  >  incrementing or decrementing the id by one, when proper access controls mechanisms
  >  aren't working as expected or may even be absent. This is the top one
  >  vulnerability in OWASP AP TOP 10 2023, named as BOLA (Broken Object
  >  Level Authorization). Don't assume this will not happen in your code
  >  base.


  ## Default options

   This generator uses default options provided in the `:generators` configuration of your application in the same way `phx.gen.html` does, except for `binary-id`, which is ignored and always set to `true` by `scribe.gen.domain`. This is a design choice to force the developer to opt-out of a secure default, instead of defaulting to a less secure default, which would require the developer to be aware why it isn't secure and to not forget to opt-in to the secure alternative. As a Scribe developer you MUST strive to always implement security in your code as an opt-out, not as an opt-in feature.


  Read the documentation for `phx.gen.html` and `phx.gen.schema` for more information on attributes.

  """
  use Mix.Task

  alias ElixirScribe.Template.RouteAPI
  alias ElixirScribe.Template.BindingAPI
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.SchemaContract
  alias Mix.Tasks.Scribe.Gen
  alias ElixirScribe.Generator.DomainResourceAPI
  alias ElixirScribe.Template.FileAPI

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix scribe.gen.html must be invoked from within your *_web application root directory"
      )
    end

    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

    case DomainResourceAPI.build_domain_resource_contract(valid_args, opts) do
      {:ok, contract} ->
        contract
        |> generate_new_files()
        |> inject_routes()
        |> print_shell_instructions()

      {:error, reasons} ->
        Mix.raise("""
        The command doesn't conform with the specification:

        #{inspect(reasons)}
        """)

      {:error, msg, context} ->
        Mix.raise("""
        #{msg}

        #{context}
        """)
    end
  end

  defp generate_new_files(%DomainContract{} = context) do
    paths = ElixirScribe.base_template_paths()
    files = files_to_be_generated(context)

    prompt_for_conflicts(context, files)

    binding =
      BindingAPI.build_binding_template(context)
      |> Keyword.merge(inputs: inputs(context.schema))

    Enum.each(files, fn {format, file_type, source_file_path, target, action} ->
      opts = [file_type: file_type]
      binding = BindingAPI.rebuild_binding_template(binding, action, opts)
      mapping = [{format, source_file_path, target}]

      Mix.Phoenix.copy_from(paths, ".", binding, mapping)
    end)

    DomainResourceAPI.generate_new_files(context, prompt_for_conflicts?: false)

    context
  end

  defp prompt_for_conflicts(context, files) do
    # @INFO - Domain Resource Action files are merged here to not become part of
    #         the files to be generated by this generator.
    context
    |> DomainResourceAPI.build_files_to_generate()
    |> Kernel.++(files)
    |> MixAPI.prompt_for_file_conflicts()
  end

  defp files_to_be_generated(
         %DomainContract{schema: _schema, context_app: _context_app} = context
       ) do
    build_files_without_action(context)
    |> build_controller_action_files(context)
    |> build_controller_test_action_files(context)
    |> build_html_action_files(context)
  end

  defp build_files_without_action(context) do
    html_template_path = FileAPI.build_dir_path_for_html_file(context)

    resource_form_source = Path.join([html_template_path, "resource_form.html.heex"])

    resource_form_target =
      Path.join([context.lib_web_resource_dir, "#{context.resource_path_name_singular}_form.html.heex"])

    not_used_action = ""

    [
      {:eex, :html, resource_form_source, resource_form_target, not_used_action},
      {:eex, :html, Path.join(html_template_path, "html.ex"),
       Path.join([context.lib_web_resource_dir, "#{context.resource_path_name_singular}_html.ex"]),
       not_used_action}
    ]
  end

  defp build_controller_action_files(files, context) do
    controller_template_path = ElixirScribe.controller_template_path()

    for action <- context.resource_actions, reduce: files do
      files ->
        template_filename = "#{action_name(action)}_controller.ex"
        source = Path.join([controller_template_path, template_filename])

        resource_name = resource_name_for_action(context, action)
        controller = "#{action_name(action)}_#{resource_name}_controller.ex"
        target = Path.join([context.lib_web_resource_dir, action, controller])

        file = {:eex, :controller, source, target, action}
        [file | files]
    end
  end

  defp build_controller_test_action_files(files, context) do
    controller_test_template_path = ElixirScribe.controller_test_template_path()

    for action <- context.resource_actions, reduce: files do
      files ->
        template_filename = "#{action_name(action)}_controller_test.exs"
        source = Path.join([controller_test_template_path, template_filename])

        resource_name = resource_name_for_action(context, action)
        controller = "#{action}_#{resource_name}_controller_test.exs"

        target =
          Path.join([
            context.test_web_domain_dir,
            context.resource_path_name_singular,
            action,
            controller
          ])

        file = {:eex, :controller_test, source, target, action}
        [file | files]
    end
  end

  defp build_html_action_files(files, context) do
    html_actions = ElixirScribe.resource_html_actions()
    html_template_path = FileAPI.build_dir_path_for_html_file(context)

    for html_action <- html_actions, reduce: files do
      files ->
        if html_action in context.resource_actions do
          template_filename = "#{action_name(html_action)}.html.heex"
          source = Path.join([html_template_path, template_filename])

          resource_name = resource_name_for_action(context, html_action)
          target_filename = "#{html_action}_#{resource_name}.html.heex"
          target = Path.join([context.lib_web_resource_dir, html_action, target_filename])

          file = {:eex, :html, source, target, html_action}
          [file | files]
        else
          files
        end
    end
  end

  defp resource_name_for_action(context, action) do
    (action in ElixirScribe.resource_plural_actions() && context.resource_path_name_plural) ||
      context.resource_path_name_singular
  end

  defp action_name(action) do
    (action in ElixirScribe.resource_actions() && action) || "default"
  end

  defp inject_routes(%DomainContract{context_app: ctx_app} = context) do
    router_file_path = Mix.Phoenix.web_path(ctx_app) |> Path.join("router.ex")
    router_scope = RouteAPI.scope_routes(context)

    FileAPI.inject_content_before_module_end(router_scope, router_file_path)

    context
  end

  defp print_shell_instructions(%DomainContract{schema: schema, context_app: ctx_app} = context) do
    router_file_path = Mix.Phoenix.web_path(ctx_app) |> Path.join("router.ex")
    router_scope = RouteAPI.scope_routes(context) |> String.trim()

    Mix.shell().info("""

    Your #{schema.web_namespace} :browser scope in #{router_file_path} should now look like this:

      #{router_scope}
    """)

    if context.generate?, do: Gen.Domain.print_shell_instructions(context)
  end

  defp inputs(%SchemaContract{} = schema) do
    schema.attrs
    |> Enum.reject(fn {_key, type} -> type == :map end)
    |> Enum.map(fn
      {key, :integer} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" />)

      {key, :float} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" step="any" />)

      {key, :decimal} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" step="any" />)

      {key, :boolean} ->
        ~s(<.input field={f[#{inspect(key)}]} type="checkbox" label="#{label(key)}" />)

      {key, :text} ->
        ~s(<.input field={f[#{inspect(key)}]} type="text" label="#{label(key)}" />)

      {key, :date} ->
        ~s(<.input field={f[#{inspect(key)}]} type="date" label="#{label(key)}" />)

      {key, :time} ->
        ~s(<.input field={f[#{inspect(key)}]} type="time" label="#{label(key)}" />)

      {key, :utc_datetime} ->
        ~s(<.input field={f[#{inspect(key)}]} type="datetime-local" label="#{label(key)}" />)

      {key, :naive_datetime} ->
        ~s(<.input field={f[#{inspect(key)}]} type="datetime-local" label="#{label(key)}" />)

      {key, {:array, _} = type} ->
        ~s"""
        <.input
          field={f[#{inspect(key)}]}
          type="select"
          multiple
          label="#{label(key)}"
          options={#{inspect(default_options(type))}}
        />
        """

      {key, {:enum, _}} ->
        ~s"""
        <.input
          field={f[#{inspect(key)}]}
          type="select"
          label="#{label(key)}"
          prompt="Choose a value"
          options={Ecto.Enum.values(#{inspect(schema.module)}, #{inspect(key)})}
        />
        """

      {key, _} ->
        ~s(<.input field={f[#{inspect(key)}]} type="text" label="#{label(key)}" />)
    end)
  end

  defp default_options({:array, :string}),
    do: Enum.map([1, 2], &{"Option #{&1}", "option#{&1}"})

  defp default_options({:array, :integer}),
    do: Enum.map([1, 2], &{"#{&1}", &1})

  defp default_options({:array, _}), do: []

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))
end
