defmodule ElixirScribe.Template.Binding.Rebuild.RebuildBindingTemplateTest do
  alias ElixirScribe.Template.BindingAPI

  use ElixirScribe.BaseCase, async: true

  test "it rebuilds the bindings for the template" do
    contract = domain_contract_fixture()

    bindings = [
      contract: contract,
      action: "build_report",
      action_first_word: "build",
      action_capitalized: "BuildReport",
      action_human_capitalized: "Build Report",
      module_action_name: "BuildReportPost",
      absolute_module_action_name: "ElixirScribe.Site.Blog.Post.BatchUpdate.BatchUpdatePost"
    ]

    expected_bindings = [
      contract: contract,
      action: "batch_update",
      action_first_word: "batch",
      action_capitalized: "BatchUpdate",
      action_human_capitalized: "Batch Update",
      module_action_name: "BatchUpdatePost",
      absolute_module_action_name: "ElixirScribe.Site.Blog.Post.BatchUpdate.BatchUpdatePost"
    ]

    assert BindingAPI.rebuild_binding_template(bindings, "batch_update", file_type: :resource) ===
             expected_bindings
  end
end
