defmodule ElixirScribe.Template.Binding.Build.BuildBindingTemplate do
  @moduledoc false

  alias ElixirScribe.Template.ModuleAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def build(%DomainContract{} = contract) do
    resource_actions = contract.resource_actions

    [contract: contract]
    |> add_resource_action_aliases(resource_actions)
    |> add_resource_action_aliases_capitalized(resource_actions)
    |> add_embeded_templates()
  end

  defp add_resource_action_aliases(binding, resource_actions) do
    new_bindings =
      resource_actions
      |> Keyword.new(fn action ->
        action_alias = ElixirScribe.resource_action_alias(action)
        action_key = String.to_atom("#{action}_action")
        {action_key, action_alias}
      end)

    Keyword.merge(binding, new_bindings)
  end

  defp add_resource_action_aliases_capitalized(binding, resource_actions) do
    new_bindings =
      resource_actions
      |> Keyword.new(&new_action_binding/1)

    Keyword.merge(binding, new_bindings)
  end

  defp new_action_binding(action) do
    action_alias_capitalized =
      action
      |> ElixirScribe.resource_action_alias()
      |> StringAPI.capitalize()

    action_key = String.to_atom("#{action}_action_capitalized")

    {action_key, action_alias_capitalized}
  end

  defp add_embeded_templates(binding) do
    Keyword.put(binding, :embeded_templates, ModuleAPI.build_embeded_templates())
  end
end
