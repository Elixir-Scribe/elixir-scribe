defmodule ElixirScribe.Template.ModuleAPI do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleName
  alias ElixirScribe.Template.Module.BuildName.BuildModuleActionName
  alias ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionName
  alias ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionNameAliases
  alias ElixirScribe.Template.Options.BuildEmbedTemplates.BuildModuleEmbedTemplates

  def build_embeded_templates(), do: BuildModuleEmbedTemplates.build()

  def build_absolute_module_action_name(%DomainContract{} = contract, action, opts)
      when is_list(opts),
      do: BuildAbsoluteModuleActionName.build(contract, action, opts)

  def build_absolute_module_action_name_aliases(%DomainContract{} = contract, opts)
      when is_list(opts),
      do: BuildAbsoluteModuleActionNameAliases.build(contract, opts)

  def build_absolute_module_name(%DomainContract{} = contract, opts) when is_list(opts),
    do: BuildAbsoluteModuleName.build(contract, opts)

  def build_module_action_name(%DomainContract{} = contract, action) when is_binary(action),
    do: BuildModuleActionName.build(contract, action)
end
