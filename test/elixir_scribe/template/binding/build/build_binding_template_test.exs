defmodule ElixirScribe.Template.Binding.Build.BuildBindingTemplateTest do
  alias ElixirScribe.Template.BindingAPI

  use ElixirScribe.BaseCase, async: true

  test "it builds the template bindings" do
    contract = domain_contract_fixture()

    expected_embeds =
      """

        embed_templates "read/*"
        embed_templates "new/*"
        embed_templates "edit/*"
        embed_templates "list/*"
      """
      |> String.trim_trailing()

    expected_bindings = [
      embeded_templates: expected_embeds,
      contract: contract,
      list_action: "list",
      new_action: "new",
      read_action: "read",
      edit_action: "edit",
      create_action: "create",
      update_action: "update",
      delete_action: "delete",
      list_action_capitalized: "List",
      new_action_capitalized: "New",
      read_action_capitalized: "Read",
      edit_action_capitalized: "Edit",
      create_action_capitalized: "Create",
      update_action_capitalized: "Update",
      delete_action_capitalized: "Delete"
    ]

    assert BindingAPI.build_binding_template(contract) === expected_bindings
  end
end
