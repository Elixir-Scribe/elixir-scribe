defmodule ElixirScribe.Generator.Domain.Resource.BuildActionFilesPaths.BuildActionFilesPathsResource do
  @moduledoc false

  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.TemplateBuilderAPI

  def build(%DomainContract{generate?: false}), do: []
  def build(%DomainContract{generate?: true} = contract), do: build_files(contract)

  defp build_files(%DomainContract{} = contract) do
    resource_actions = contract.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      source_path = build_source_path(contract.schema, action)
      target_path = build_target_path(contract, action)

      {:eex, :resource, source_path, target_path, action}
    end
  end

  defp build_target_path(contract, action) do
    plural_actions = ElixirScribe.resource_plural_actions()
    resource_name = action in plural_actions && contract.resource_name_plural || contract.resource_name_singular
    filename = "#{action}_" <> resource_name <> ".ex"

    Path.join([contract.lib_resource_dir, action, filename])
  end

  defp build_source_path(schema, action) do
    resource_action_path = ElixirScribe.resource_actions_template_path()
    schema_folder = ElixirScribe.schema_template_folder_name(schema)
    action_template_filename = build_template_action_filename(action, schema.generate?)

    Path.join([resource_action_path, schema_folder, action_template_filename])
  end

  defp build_template_action_filename(action, true) do
    TemplateBuilderAPI.build_template_action_filename(action, "_", "schema", ".ex")
  end
  defp build_template_action_filename(_action, false), do: "any_action.ex"
end
