defmodule ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource do
  @moduledoc false

  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.FileAPI

  def build(%DomainContract{} = contract) do
    resource_actions = contract.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      source_path = build_source_path(contract.schema, action)
      target_path = build_target_path(contract, action)

      {:eex, :resource, source_path, target_path, action}
    end
  end

  defp build_source_path(schema, action) do
    resource_action_path = ElixirScribe.resource_actions_template_path()
    schema_folder = ElixirScribe.schema_template_folder_name(schema)
    action_template_filename = build_template_action_filename(action, schema.generate?)

    Path.join([resource_action_path, schema_folder, action_template_filename])
  end

  defp build_target_path(contract, action) do
    action_name =
      action
      |> maybe_add_resource_name(contract)
      |> maybe_add_domain_name(contract)

    filename =
      action_name
      |> Kernel.<>("_handler.ex")

    Path.join([contract.lib_resource_dir, action_name, filename])
  end

  defp maybe_add_resource_name(action, contract) do
    plural_actions = ElixirScribe.resource_plural_actions()

    resource_name =
      (action in plural_actions && contract.resource_name_plural) ||
        contract.resource_name_singular

    case action |> String.contains?(resource_name) do
      true ->
        action

      false ->
        "#{action}_#{resource_name}"
    end
  end

  defp maybe_add_domain_name(action_filename, contract) do
    domain_name = contract.name |> String.split(".") |> List.last() |> String.downcase()

    domain_name = domain_name |> String.trim_trailing("s")

    case action_filename |> String.contains?(domain_name) do
      true ->
        action_filename

      false ->
        "#{action_filename}_#{domain_name}"
    end
  end

  defp build_template_action_filename(action, true) do
    attrs = %{action: action, action_suffix: "_", file_type: "schema", file_extension: ".ex"}

    contract = BuildFilenameForActionFileContract.new!(attrs)

    FileAPI.build_template_action_filename(contract)
  end

  defp build_template_action_filename(_action, false), do: "any_action.ex"
end
