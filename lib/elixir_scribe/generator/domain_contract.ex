defmodule ElixirScribe.Generator.DomainContract do
  @moduledoc false

  # This contract mirrors the Mix.Phoenix.Context module from the Phoenix
  # Framework with some added fields to suite ElixirScribe needs.

  @required [
    :name,
    :module,
    :resource_module,
    :resource_module_plural,
    :schema,
    :alias,
    :base_module,
    :web_module,
    :web_domain_module,
    :web_resource_module,
    :web_resource_module_plural,
    :basename,
    :api_file,
    :test_file,
    :test_fixtures_file,
    :lib_web_domain_dir,
    :lib_domain_dir,
    :lib_web_resource_dir,
    :lib_web_resource_dir_plural,
    :lib_resource_dir,
    :lib_resource_dir_plural,
    :test_web_domain_dir,
    :test_domain_dir,
    :test_web_resource_dir,
    :test_web_resource_dir_plural,
    :test_resource_dir,
    :test_resource_dir_plural,
    :context_app,
    :resource_path_name_singular,
    :resource_path_name_plural,
    :resource_actions
  ]

  @optional [
    generate?: true,
    opts: []
  ]

  use ElixirScribe.Behaviour.TypedContract, keys: %{required: @required, optional: @optional}

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      name: is_binary() |> spec(),
      module: is_atom() |> spec(),
      resource_module: is_atom() |> spec(),
      resource_module_plural: is_atom() |> spec(),
      schema: spec(is_struct() or is_nil()),
      alias: is_atom() |> spec(),
      base_module: is_atom() |> spec(),
      web_module: is_atom() |> spec(),
      web_domain_module: is_atom() |> spec(),
      web_resource_module: is_atom() |> spec(),
      web_resource_module_plural: is_atom() |> spec(),
      basename: is_binary() |> spec(),
      api_file: is_binary() |> spec(),
      test_file: is_binary() |> spec(),
      test_fixtures_file: is_binary() |> spec(),
      lib_web_domain_dir: is_binary() |> spec(),
      lib_domain_dir: is_binary() |> spec(),
      lib_web_resource_dir: is_binary() |> spec(),
      lib_web_resource_dir_plural: is_binary() |> spec(),
      lib_resource_dir: is_binary() |> spec(),
      lib_resource_dir_plural: is_binary() |> spec(),
      test_web_domain_dir: is_binary() |> spec(),
      test_domain_dir: is_binary() |> spec(),
      test_web_resource_dir: is_binary() |> spec(),
      test_web_resource_dir_plural: is_binary() |> spec(),
      test_resource_dir: is_binary() |> spec(),
      test_resource_dir_plural: is_binary() |> spec(),
      generate?: is_boolean() |> spec(),
      context_app: is_atom() |> spec(),
      resource_actions: is_list() |> spec(),
      resource_path_name_singular: is_binary() |> spec(),
      resource_path_name_plural: is_binary() |> spec(),
      opts: is_list() |> spec()
    })
  end
end
