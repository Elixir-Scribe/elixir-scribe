defmodule ElixirScribe.Generator.Schema.Resource.BuildSchemaResourceContract do
  @moduledoc false
  alias ElixirScribe.Generator.SchemaContract

  def build(args, opts) when is_list(args) and is_list(opts), do: new(args, opts)

  def build!(args, opts) when is_list(args) and is_list(opts), do: new!(args, opts)

  defp new!(args, opts) do
    case new(args, opts) do
      {:ok, contract} ->
        contract

      {:error, reason} ->
        raise reason
    end
  end

  defp new(args, opts) do
    with :ok <- validate_args!(args) do
      [domain_name | schema_args] = args
      [resource_name, schema_plural | cli_attrs] = schema_args
      resource_name = domain_name |> Module.concat(resource_name) |> inspect()

      opts = Keyword.put(opts, :web, domain_name)

      ctx_app = extract_option_context_app(opts)
      otp_app = Mix.Phoenix.otp_app()
      opts = Keyword.merge(Application.get_env(otp_app, :generators, []), opts)
      base = Mix.Phoenix.context_base(ctx_app)
      basename = Phoenix.Naming.underscore(resource_name)
      module = Module.concat([base, resource_name])

      singular =
        module
        |> Module.split()
        |> List.last()
        |> Phoenix.Naming.underscore()

      repo = extract_option_repo(opts, base)
      repo_alias = build_repo_module_alias(repo)

      schema_file_path = Path.join(["domain", basename, singular <> "_schema.ex"])
      file = Mix.Phoenix.context_lib_path(ctx_app, schema_file_path)

      table = opts[:table] || schema_plural
      {cli_attrs, uniques, redacts} = extract_attr_flags(cli_attrs)
      {assocs, attrs} = partition_attrs_and_assocs(module, parse_attrs(cli_attrs))
      types = types(attrs)
      web_namespace = opts[:web] && Phoenix.Naming.camelize(opts[:web])
      web_path = web_namespace && Phoenix.Naming.underscore(web_namespace)
      api_prefix = Application.get_env(otp_app, :generators)[:api_prefix] || "/api"

      embedded? = Keyword.get(opts, :embedded, false)
      generate? = Keyword.get(opts, :schema, true)

      collection =
        if schema_plural == singular, do: singular <> "_collection", else: schema_plural

      string_attr = string_attr(types)
      create_params = params(attrs, :create)

      optionals = for {key, :map} <- types, do: key, into: []

      default_params_key =
        case Enum.at(create_params, 0) do
          {key, _} -> key
          nil -> :some_field
        end

      fixture_unique_functions = fixture_unique_functions(singular, uniques, attrs)

      SchemaContract.new(%{
        opts: opts,
        module: module,
        repo: repo,
        repo_alias: repo_alias,
        table: table,
        embedded?: embedded?,
        alias: module |> Module.split() |> List.last() |> Module.concat(nil),
        file: file,
        attrs: attrs,
        plural: schema_plural,
        singular: singular,
        collection: collection,
        optionals: optionals,
        assocs: assocs,
        types: types,
        defaults: schema_defaults(attrs),
        uniques: uniques,
        redacts: redacts,
        indexes: indexes(table, assocs, uniques),
        human_singular: Phoenix.Naming.humanize(singular),
        human_plural: Phoenix.Naming.humanize(schema_plural),
        binary_id: true,
        timestamp_type: opts[:timestamp_type] || :naive_datetime,
        migration_defaults: migration_defaults(attrs),
        string_attr: string_attr,
        params: %{
          create: create_params,
          update: params(attrs, :update),
          default_key: string_attr || default_params_key
        },
        web_namespace: web_namespace,
        web_path: web_path,
        route_helper: route_helper(web_path, singular),
        route_prefix: route_prefix(web_path, schema_plural),
        api_route_prefix: api_route_prefix(web_path, schema_plural, api_prefix),
        sample_id: sample_id(opts),
        context_app: ctx_app,
        generate?: generate?,
        migration?: Keyword.get(opts, :migration, true),
        migration_module: migration_module(),
        migration_dir: extract_option_migration_dir(opts),
        fixture_unique_functions: Enum.sort(fixture_unique_functions),
        fixture_params: fixture_params(attrs, fixture_unique_functions),
        prefix: opts[:prefix]
      })
    end
  end

  # defp validate_args!(domain_name, resource_name) do
  defp validate_args!([domain_name, resource_name, schema_plural | _] = _args) do
    cond do
      not valid?(domain_name) ->
        build_error_with_help("""
        Expected the Domain, #{inspect(domain_name)}, to be a valid module name.

        Each Domain segment MUST start with a capital letter.

        Valid:
        - Sales
        - Sales.Catalog

        Invalid:
        - sales
        - sales.catalog
        """)

      not valid?(resource_name) ->
        build_error_with_help("""
        Expected the Resource, #{inspect(resource_name)}, to be a valid module name.

        The Resource name MUST start with a capital letter.

        Valid:
        - Category

        Invalid:
        - category
        """)

      domain_name == resource_name ->
        build_error_with_help("The Domain and Resource should have different names")

      domain_name == Mix.Phoenix.base() ->
        build_error_with_help(
          "Cannot generate Domain #{domain_name} because it has the same name as the application"
        )

      resource_name == Mix.Phoenix.base() ->
        build_error_with_help(
          "Cannot generate Resource #{resource_name} because it has the same name as the application"
        )

      String.contains?(schema_plural, ":") or
          schema_plural != Phoenix.Naming.underscore(schema_plural) ->
        build_error_with_help(
          "Expected the schema plural argument, #{inspect(schema_plural)}, to be all lowercase using snake_case convention"
        )

      true ->
        :ok
    end
  end

  defp validate_args!(args) when length(args) == 2 do
    build_error_with_help(
      "Missing the schema table name for the resource. Needs to be lowercase and in the plural form."
    )
  end

  defp validate_args!(args) when length(args) == 1 do
    build_error_with_help(
      "Missing the resource name and schema table name. Resource name needs to capitalized and the schema name needs to be lowercase and in the plural form."
    )
  end

  defp validate_args!(_args) do
    build_error_with_help("No arguments were provided.")
  end

  defp valid?(module_name) do
    module_name =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  defp params(attrs, action) when action in [:create, :update] do
    Map.new(attrs, fn {k, t} -> {k, type_to_default(k, t, action)} end)
  end

  defp build_error_with_help(msg) do
    error =
      """
      #{msg}

      ## Usage

      The command `mix scribe.gen.schema` expects a Domain, followed by singular
      and plural names of a resource, ending with any number of attributes that
      will define the database table and schema.

      For example:

      mix scribe.gen.schema Catalog Product products name:string, desc: string

      The schema file will be generated at lib/my_app/domain/catalog/product/product_schema.ex

      Notes:

      A Domain can be nested to create better bounded contexts:
      - Sales
      - Sales.Catalog
      - B2B.Sales.Catalog
      - B2C.Sales.Catalog

      The API boundary for each resource in a Domain is located at the root of a
      resource, `MyApp.Sales.Catalog.CategoryAPI`.

      A Domain is usually composed of multiple resources and all possible actions
      on a resource.
      """

    {:error, error}
  end

  defp extract_option_context_app(opts) when is_list(opts) do
    opts
    |> Keyword.get(:context_app)
    |> extract_option_context_app()
  end

  defp extract_option_context_app(nil), do: Mix.Phoenix.context_app()
  defp extract_option_context_app(app_name) when is_atom(app_name), do: app_name

  defp extract_option_context_app(app_name) when is_binary(app_name),
    do: app_name |> String.to_existing_atom()

  defp extract_option_repo(opts, base) when is_list(opts) and is_binary(base) do
    opts
    |> Keyword.get(:repo)
    |> extract_option_repo(base)
  end

  defp extract_option_repo(nil, base), do: Module.concat([base, "Repo"])

  # defp extract_option_repo(module_name, _base) when is_atom(module_name), do: module_name

  defp extract_option_repo(module_name, _base), do: Module.concat([module_name])

  defp build_repo_module_alias(repo) when is_atom(repo) do
    repo
    |> Atom.to_string()
    |> build_repo_module_alias()
  end

  defp build_repo_module_alias(repo) when is_binary(repo) do
    if String.ends_with?(repo, ".Repo"), do: "", else: ", as: Repo"
  end

  defp extract_option_migration_dir(opts) do
    opts
    |> Keyword.get(:migrations_dir, "priv/repo/migrations")
  end

  defp extract_attr_flags(cli_attrs) do
    {attrs, uniques, redacts} =
      Enum.reduce(cli_attrs, {[], [], []}, fn attr, {attrs, uniques, redacts} ->
        [attr_name | rest] = String.split(attr, ":")
        attr_name = String.to_atom(attr_name)
        split_flags(Enum.reverse(rest), attr_name, attrs, uniques, redacts)
      end)

    {Enum.reverse(attrs), uniques, redacts}
  end

  defp split_flags(["unique" | rest], name, attrs, uniques, redacts),
    do: split_flags(rest, name, attrs, [name | uniques], redacts)

  defp split_flags(["redact" | rest], name, attrs, uniques, redacts),
    do: split_flags(rest, name, attrs, uniques, [name | redacts])

  defp split_flags(rest, name, attrs, uniques, redacts),
    do: {[Enum.join([name | Enum.reverse(rest)], ":") | attrs], uniques, redacts}

  defp parse_attrs(attrs) do
    Enum.map(attrs, fn attr ->
      attr
      |> String.split(":", parts: 3)
      |> list_to_attr()
      |> validate_attr!()
    end)
  end

  defp list_to_attr([key]), do: {String.to_atom(key), :string}
  defp list_to_attr([key, value]), do: {String.to_atom(key), String.to_atom(value)}

  defp list_to_attr([key, comp, value]) do
    {String.to_atom(key), {String.to_atom(comp), String.to_atom(value)}}
  end

  @one_day_in_seconds 24 * 3600

  defp type_to_default(key, t, :create) do
    case t do
      {:array, type} ->
        build_array_values(type, :create)

      {:enum, values} ->
        build_enum_values(values, :create)

      :integer ->
        42

      :float ->
        120.5

      :decimal ->
        "120.5"

      :boolean ->
        true

      :map ->
        %{}

      :text ->
        "some #{key}"

      :date ->
        Date.add(Date.utc_today(), -1)

      :time ->
        ~T[14:00:00]

      :time_usec ->
        ~T[14:00:00.000000]

      :uuid ->
        "7488a646-e31f-11e4-aace-600308960662"

      :utc_datetime ->
        DateTime.add(
          build_utc_datetime(),
          -@one_day_in_seconds,
          :second,
          Calendar.UTCOnlyTimeZoneDatabase
        )

      :utc_datetime_usec ->
        DateTime.add(
          build_utc_datetime_usec(),
          -@one_day_in_seconds,
          :second,
          Calendar.UTCOnlyTimeZoneDatabase
        )

      :naive_datetime ->
        NaiveDateTime.add(build_utc_naive_datetime(), -@one_day_in_seconds)

      :naive_datetime_usec ->
        NaiveDateTime.add(build_utc_naive_datetime_usec(), -@one_day_in_seconds)

      _ ->
        "some #{key}"
    end
  end

  defp type_to_default(key, t, :update) do
    case t do
      {:array, type} -> build_array_values(type, :update)
      {:enum, values} -> build_enum_values(values, :update)
      :integer -> 43
      :float -> 456.7
      :decimal -> "456.7"
      :boolean -> false
      :map -> %{}
      :text -> "some updated #{key}"
      :date -> Date.utc_today()
      :time -> ~T[15:01:01]
      :time_usec -> ~T[15:01:01.000000]
      :uuid -> "7488a646-e31f-11e4-aace-600308960668"
      :utc_datetime -> build_utc_datetime()
      :utc_datetime_usec -> build_utc_datetime_usec()
      :naive_datetime -> build_utc_naive_datetime()
      :naive_datetime_usec -> build_utc_naive_datetime_usec()
      _ -> "some updated #{key}"
    end
  end

  defp build_array_values(:string, :create),
    do: Enum.map([1, 2], &"option#{&1}")

  defp build_array_values(:integer, :create),
    do: [1, 2]

  defp build_array_values(:string, :update),
    do: ["option1"]

  defp build_array_values(:integer, :update),
    do: [1]

  defp build_array_values(_, _),
    do: []

  defp build_enum_values(values, action) do
    case {action, translate_enum_vals(values)} do
      {:create, vals} -> hd(vals)
      {:update, [val | []]} -> val
      {:update, vals} -> vals |> tl() |> hd()
    end
  end

  defp build_utc_datetime_usec,
    do: %{DateTime.utc_now() | second: 0, microsecond: {0, 6}}

  defp build_utc_datetime,
    do: DateTime.truncate(build_utc_datetime_usec(), :second)

  defp build_utc_naive_datetime_usec,
    do: %{NaiveDateTime.utc_now() | second: 0, microsecond: {0, 6}}

  defp build_utc_naive_datetime,
    do: NaiveDateTime.truncate(build_utc_naive_datetime_usec(), :second)

  @valid_types [
    :integer,
    :float,
    :decimal,
    :boolean,
    :map,
    :string,
    :array,
    :references,
    :text,
    :date,
    :time,
    :time_usec,
    :naive_datetime,
    :naive_datetime_usec,
    :utc_datetime,
    :utc_datetime_usec,
    :uuid,
    :binary,
    :enum
  ]

  @enum_missing_value_error """
  Enum type requires at least one value
  For example:

      mix phx.gen.schema Comment comments body:text status:enum:published:unpublished
  """

  defp validate_attr!({name, :datetime}), do: validate_attr!({name, :naive_datetime})

  defp validate_attr!({name, :array}) do
    Mix.raise("""
    Phoenix generators expect the type of the array to be given to #{name}:array.
    For example:

        mix phx.gen.schema Post posts settings:array:string
    """)
  end

  defp validate_attr!({_name, :enum}), do: Mix.raise(@enum_missing_value_error)
  defp validate_attr!({_name, type} = attr) when type in @valid_types, do: attr
  defp validate_attr!({_name, {:enum, _vals}} = attr), do: attr
  defp validate_attr!({_name, {type, _}} = attr) when type in @valid_types, do: attr

  defp validate_attr!({_, type}) do
    Mix.raise(
      "Unknown type `#{inspect(type)}` given to generator. " <>
        "The supported types are: #{@valid_types |> Enum.sort() |> Enum.join(", ")}"
    )
  end

  defp partition_attrs_and_assocs(schema_module, attrs) do
    {assocs, attrs} =
      Enum.split_with(attrs, fn
        {_, {:references, _}} ->
          true

        {key, :references} ->
          Mix.raise("""
          Phoenix generators expect the table to be given to #{key}:references.
          For example:

              mix phx.gen.schema Comment comments body:text post_id:references:posts
          """)

        _ ->
          false
      end)

    assocs =
      Enum.map(assocs, fn {key_id, {:references, source}} ->
        key = String.replace(Atom.to_string(key_id), "_id", "")
        base = schema_module |> Module.split() |> Enum.drop(-1)
        module = Module.concat(base ++ [Phoenix.Naming.camelize(key)])
        {String.to_atom(key), key_id, inspect(module), source}
      end)

    {assocs, attrs}
  end

  defp schema_defaults(attrs) do
    Enum.into(attrs, %{}, fn
      {key, :boolean} -> {key, ", default: false"}
      {key, _} -> {key, ""}
    end)
  end

  defp string_attr(types) do
    Enum.find_value(types, fn
      {key, :string} -> key
      _ -> false
    end)
  end

  defp types(attrs) do
    Enum.into(attrs, %{}, fn
      {key, {:enum, vals}} -> {key, {:enum, values: translate_enum_vals(vals)}}
      {key, {root, val}} -> {key, {root, schema_type(val)}}
      {key, val} -> {key, schema_type(val)}
    end)
  end

  def translate_enum_vals(vals) do
    vals
    |> Atom.to_string()
    |> String.split(":")
    |> Enum.map(&String.to_atom/1)
  end

  defp schema_type(:text), do: :string
  defp schema_type(:uuid), do: Ecto.UUID

  defp schema_type(val) do
    if Code.ensure_loaded?(Ecto.Type) and not Ecto.Type.primitive?(val) do
      Mix.raise("Unknown type `#{val}` given to generator")
    else
      val
    end
  end

  defp indexes(table, assocs, uniques) do
    uniques = Enum.map(uniques, fn key -> {key, true} end)
    assocs = Enum.map(assocs, fn {_, key, _, _} -> {key, false} end)

    (uniques ++ assocs)
    |> Enum.uniq_by(fn {key, _} -> key end)
    |> Enum.map(fn
      {key, false} -> "create index(:#{table}, [:#{key}])"
      {key, true} -> "create unique_index(:#{table}, [:#{key}])"
    end)
  end

  defp migration_defaults(attrs) do
    Enum.into(attrs, %{}, fn
      {key, :boolean} -> {key, ", default: false, null: false"}
      {key, _} -> {key, ""}
    end)
  end

  defp sample_id(opts) do
    # if Keyword.get(opts, :binary_id, false) do
    Keyword.get(opts, :sample_binary_id, "11111111-1111-1111-1111-111111111111")
    # else
    # -1
    # end
  end

  defp route_helper(web_path, singular) do
    "#{web_path}_#{singular}"
    |> String.trim_leading("_")
    |> String.replace("/", "_")
  end

  defp route_prefix(web_path, plural) do
    path = Path.join(for str <- [web_path, plural], do: to_string(str))
    "/" <> String.trim_leading(path, "/")
  end

  defp api_route_prefix(web_path, plural, api_prefix) do
    path = Path.join(for str <- [api_prefix, web_path, plural], do: to_string(str))
    "/" <> String.trim_leading(path, "/")
  end

  defp migration_module do
    case Application.get_env(:ecto_sql, :migration_module, Ecto.Migration) do
      migration_module when is_atom(migration_module) -> migration_module
      other -> Mix.raise("Expected :migration_module to be a module, got: #{inspect(other)}")
    end
  end

  defp fixture_unique_functions(singular, uniques, attrs) do
    uniques
    |> Enum.filter(&Keyword.has_key?(attrs, &1))
    |> Enum.into(%{}, fn attr ->
      function_name = "unique_#{singular}_#{attr}"

      {function_def, needs_impl?} =
        case Keyword.fetch!(attrs, attr) do
          :integer ->
            function_def =
              """
                def #{function_name}, do: System.unique_integer([:positive])
              """

            {function_def, false}

          type when type in [:string, :text] ->
            function_def =
              """
                def #{function_name}, do: "some #{attr}\#{System.unique_integer([:positive])}"
              """

            {function_def, false}

          _ ->
            function_def =
              """
                def #{function_name} do
                  raise "implement the logic to generate a unique #{singular} #{attr}"
                end
              """

            {function_def, true}
        end

      {attr, {function_name, function_def, needs_impl?}}
    end)
  end

  defp fixture_params(attrs, fixture_unique_functions) do
    attrs
    |> Enum.sort()
    |> Enum.map(fn {attr, type} ->
      case fixture_unique_functions do
        %{^attr => {function_name, _function_def, _needs_impl?}} ->
          {attr, "#{function_name}()"}

        %{} ->
          {attr, inspect(type_to_default(attr, type, :create))}
      end
    end)
  end
end
