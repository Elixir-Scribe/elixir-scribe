defmodule ElixirScribe.Generator.SchemaContract do
  @moduledoc false

  # This module was borrowed from the Phoenix Framework module
  # Mix.Phoenix.Schema and modified to suite ElixirScribe needs.

  # @TODO Extract the custom logic to build the contract to a separate module, like done with the %DomainContract{}

  @optional [
    module: nil,
    repo: nil,
    repo_alias: nil,
    table: nil,
    collection: nil,
    embedded?: false,
    generate?: true,
    opts: [],
    alias: nil,
    alias_plural: nil,
    file: nil,
    attrs: [],
    string_attr: nil,
    plural: nil,
    singular: nil,
    uniques: [],
    redacts: [],
    assocs: [],
    types: [],
    indexes: [],
    defaults: [],
    human_singular: nil,
    human_plural: nil,
    binary_id: false,
    migration_defaults: nil,
    migration?: false,
    migration_dir: nil,
    params: %{},
    optionals: [],
    sample_id: nil,
    web_path: nil,
    web_namespace: nil,
    context_app: nil,
    route_helper: nil,
    route_prefix: nil,
    api_route_prefix: nil,
    migration_module: nil,
    fixture_unique_functions: [],
    fixture_params: [],
    prefix: nil,
    timestamp_type: :naive_datetime
  ]

  use ElixirScribe.Behaviour.TypedContract, keys: %{required: [], optional: @optional}

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      module: is_atom() |> spec(),
      repo: is_atom() |> spec(),
      repo_alias: is_binary() |> spec(),
      table: is_binary() |> spec(),
      collection: is_binary() |> spec(),
      embedded?: is_boolean() |> spec(),
      generate?: is_boolean() |> spec(),
      opts: [],
      alias: is_atom() |> spec(),
      alias_plural: is_atom() |> spec(),
      file: is_binary() |> spec(),
      attrs: [],
      string_attr: is_atom() |> spec(),
      plural: is_binary() |> spec(),
      singular: is_binary() |> spec(),
      uniques: [],
      redacts: [],
      assocs: [],
      types: [],
      indexes: [],
      defaults: [],
      human_singular: is_binary() |> spec(),
      human_plural: is_binary() |> spec(),
      binary_id: is_boolean() |> spec(),
      migration_defaults: is_map() |> spec(),
      migration?: is_boolean() |> spec(),
      migration_dir: is_binary() |> spec(),
      params: %{},
      optionals: [],
      sample_id: is_binary() |> spec(),
      web_path: is_binary() |> spec(),
      web_namespace: is_binary() |> spec(),
      context_app: is_atom() |> spec(),
      route_helper: is_binary() |> spec(),
      route_prefix: is_binary() |> spec(),
      api_route_prefix: is_binary() |> spec(),
      migration_module: is_atom() |> spec(),
      fixture_unique_functions: [],
      fixture_params: [],
      prefix: spec(is_binary() or is_nil()),
      timestamp_type: is_atom() |> spec()
    })
  end
end
