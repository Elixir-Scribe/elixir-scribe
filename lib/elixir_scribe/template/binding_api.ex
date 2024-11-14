defmodule ElixirScribe.Template.BindingAPI do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.Binding.Build.BuildBindingTemplate
  alias ElixirScribe.Template.Binding.Rebuild.RebuildBindingTemplate

  def build_binding_template(%DomainContract{} = contract),
    do: BuildBindingTemplate.build(contract)

  def rebuild_binding_template(binding, action, opts),
    do: RebuildBindingTemplate.rebuild(binding, action, opts)
end
