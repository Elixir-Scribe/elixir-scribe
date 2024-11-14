defmodule ElixirScribe.Template.Module.BuildName.BuildModuleActionName do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%DomainContract{} = contract, action) when is_binary(action) do
    action
    |> maybe_add_resource_name(contract)
    |> maybe_add_domain_name(contract)
  end

  defp maybe_add_resource_name(action, contract) do
    resource_name =
      (action in ElixirScribe.resource_plural_actions() && contract.schema.human_plural) ||
        contract.schema.human_singular

    resource_name = resource_name |> StringAPI.capitalize()

    module_name = action |> StringAPI.capitalize()

    case module_name |> String.contains?(resource_name) do
      true ->
        module_name

      false ->
        "#{module_name}#{resource_name}"
    end
  end

  defp maybe_add_domain_name(module_name, contract) do
    domain_name = contract.name |> String.split(".") |> List.last() |> String.trim_trailing("s")

    case module_name |> String.contains?(domain_name) do
      true ->
        module_name

      false ->
        "#{module_name}#{domain_name}"
    end
  end
end
