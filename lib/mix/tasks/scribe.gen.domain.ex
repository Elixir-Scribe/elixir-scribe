defmodule Mix.Tasks.Scribe.Gen.Domain do
  # This module was borrowed from the Phoenix Framework module
  # Mix.Tasks.Phx.Gen.Context and modified to suite ElixirScribe needs.

  @shortdoc "Generates a module per action for a resource within a domain, to wrap an Ecto schema"

  @moduledoc """
  Generates a module per action for a resource within a domain, with functions around an Ecto schema.

  The goal and motivation is to encourage developers to write cleaner code in a more organized folder structure, enabling them to know in seconds all domains, resources, and actions used in a project. This  also contributes to reduce the technical debt via less complexity and clear boundaries between domains, resources and actions.


  ## Usage Examples

  The `scribe.gen.domain` generator will generate files in both `lib/my_app/*` and `tests/*` folders with the same hierarchy structure.

  Usually this command isn't used directly, unless you only want to reap it's benefits for the code at `lib/my_app/*`, but not at `lib/my_app_web/*`. Most commonly usage is for the domain generator to be invoked from `scribe.gen.html` or `scribe.gen.live`.

  For example, to create a fictitious online shop app you may start with this command:

  ```
  mix scribe.gen.domain Catalog Category categories name:string desc:string
  ```

  The first argument is the domain name followed by the resource name and its plural name, which is also used as the schema table name.

  By default the command will generate some default actions for each resource on
  a domain: `["list", "new", "read", "edit", "create", "update", "delete"]`

  We can also pass as many custom actions as we want with the flag `--actions`:

  ```
  $ mix scribe.gen.domain Catalog Product products name:string desc:string --actions import,export
  ```

  When don't need to use the default actions, then just pass the flag `--no-default-actions`:

  ```
  mix scribe.gen.domain Warehouse Stock stocks product_id:integer quantity:integer --actions import,export --no-default-actions
  ```

  ### The folder structure

  By using the previous command examples we get this folder structure:

  ```text
  lib/my_app
  ├── catalog
  │   ├── category
  │   │   ├── create
  │   │   ├── delete
  │   │   ├── edit
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
          ├── export
          └── import
  ```

  > Domains: catalog, warehouse
  > Resources: category, product, stock
  > Actions: create, delete, edit, export, import, list, new, read, update

  This is a very simplistic view of a project. Now, imagine reaping the benefits
  of this folder structure implemented on your extensive codebase, which may now
  contain dozens, hundreds, or even thousands of resources, each with
  potentially more actions than the ones exemplified here.


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
  mix scribe.gen.domain Accounts Company companies --no-schema
  ```

  ## The Database Table

  By default, the table name for the migration and schema will be
  the plural name provided for the resource. To customize this value,
  a `--table` option may be provided.

  For example:

  ```
  mix scribe.gen.domain Accounts User users --table cms_users
  ```

  ## Binary ID by Default

  By default the generated migration uses `binary_id` for schema's primary key
  and its references. No toggle is provided to use numeric IDs, because they are
  the first vulnerability listed in OWASP API TOP 10 2023.


  >### Security Implications of using numeric IDs {: .warning}
  > Numeric IDs allows an attacker to easily enumerate all resources by
  > incrementing or decrementing the id by one, when proper access controls mechanisms
  > aren't working as expected or may even be absent. This is the top one
  > vulnerability in OWASP API TOP 10 2023, named as BOLA (Broken Object
  > Level Authorization). Don't assume this will never happen in your code
  > base.


  ## Default options

  This generator uses default options provided in the `:generators` configuration of your application in the same way `phx.gen.html` does, except for `binary-id`, which is ignored and always set to `true` by `scribe.gen.domain`. This is a design choice as per previous section on the use of Binary ID by Default.

  Read the documentation for `phx.gen.context` and `phx.gen.schema` for more information on attributes.

  """

  use Mix.Task

  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainContract
  alias Mix.Tasks.Phx.Gen
  alias ElixirScribe.Generator.DomainResourceAPI

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix scribe.gen.domain must be invoked from within your *_web application root directory"
      )
    end

    {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

    case DomainResourceAPI.build_domain_resource_contract(valid_args, opts) do
      {:ok, contract} ->
        contract
        |> DomainResourceAPI.generate_new_files()
        |> print_shell_instructions()

      {:error, reason} ->
        Mix.raise(reason)
    end
  end

  @doc false
  def print_shell_instructions(%DomainContract{schema: schema}) do
    if schema.generate? do
      attrs = Map.from_struct(schema)
      schema = struct(Mix.Phoenix.Schema, attrs)

      Gen.Schema.print_shell_instructions(schema)
    else
      :ok
    end
  end
end
