defmodule ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResource do
  @moduledoc false

  alias ElixirScribe.TemplateModuleAPI
  alias ElixirScribe.TemplateBindingAPI
  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.TemplateFileAPI
  alias ElixirScribe.Generator.DomainResourceAPI

  def generate(%DomainContract{generate?: false}), do: []

  def generate(%DomainContract{generate?: true} = contract) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = TemplateBindingAPI.build_binding_template(contract)

    contract
    |> ensure_api_file_exists(base_template_paths, binding)
    |> inject_api_functions(base_template_paths, binding)

    contract
  end

  defp build_api_binding(contract, binding) do
    Keyword.merge(binding,
      absolute_module_name:
        TemplateModuleAPI.build_absolute_module_name(contract, file_type: :lib_core),
      aliases:
        TemplateModuleAPI.build_absolute_module_action_name_aliases(contract,
          file_type: :lib_core
        )
    )
  end

  defp ensure_api_file_exists(contract, base_template_paths, binding) do
    binding = build_api_binding(contract, binding)

    unless File.exists?(contract.api_file) do
      {:eex, :api, source_path, target_path} = DomainResourceAPI.build_api_file_paths(contract)

      Mix.Generator.create_file(
        target_path,
        Mix.Phoenix.eval_from(base_template_paths, source_path, binding)
      )
    end

    contract
  end

  defp inject_api_functions(contract, base_template_paths, binding) do
    resource_actions = contract.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions do
      binding =
        build_api_binding(contract, binding)
        |> TemplateBindingAPI.rebuild_binding_template(action, file_type: :lib_core)

      api_action_template_path = build_api_action_template_path(action, contract.schema.generate?)

      # base_template_paths
      # |> Mix.Phoenix.eval_from(api_action_template_path, binding)
      # |> TemplateFileAPI.inject_eex_before_final_end(contract.api_file, binding)

      TemplateFileAPI.inject_eex_before_final_end(base_template_paths, api_action_template_path, contract.api_file, binding)
    end
  end

  defp build_api_action_template_path(action, true) do
    attrs = %{
      action: action,
      action_suffix: "_",
      file_type: "api_function",
      file_extension: ".ex"
    }

    contract = BuildFilenameForActionFileContract.new!(attrs)

    action_template_filename = TemplateFileAPI.build_template_action_filename(contract)

    ElixirScribe.domain_api_template_path() |> Path.join(action_template_filename)
  end

  defp build_api_action_template_path(_action, false) do
    ElixirScribe.domain_api_template_path()
    |> Path.join("api_function_no_schema_access.ex")
  end
end
