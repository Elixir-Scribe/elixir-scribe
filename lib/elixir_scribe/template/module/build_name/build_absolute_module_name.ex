defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleName do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract

  def build(%DomainContract{} = _contract, file_type: :html), do: nil

  def build(%DomainContract{} = contract, opts) when is_list(opts),
    do: module_name(contract, opts)

  @core_files [:resource, :resource_test, :lib_core, :test_core]
  defp module_name(contract, file_type: type) when type in @core_files,
    do: contract.resource_module

  @web_files [:lib_web, :controller, :controller_test, :test_web]
  defp module_name(contract, file_type: type) when type in @web_files,
    do: contract.web_resource_module
end
