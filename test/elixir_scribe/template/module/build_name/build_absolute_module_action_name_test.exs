defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionNameTest do
  alias ElixirScribe.Template.ModuleAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds the absolute module name for the given action" do
    contract = domain_contract_fixture()

    assert ModuleAPI.build_absolute_module_action_name(contract, "read", file_type: :lib_core) ===
             "ElixirScribe.Site.Blog.Post.Read.ReadPost"
  end

  test "it returns nil when the file type is HTML" do
    contract = domain_contract_fixture()

    assert ModuleAPI.build_absolute_module_action_name(contract, "read", file_type: :html) === nil
  end
end
