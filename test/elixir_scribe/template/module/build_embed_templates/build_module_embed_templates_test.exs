defmodule ElixirScribe.Template.Options.BuildEmbedTemplates.BuildModuleEmbedTemplatesTest do
  alias ElixirScribe.Template.ModuleAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds an build_embeded_templates statement for each HTML resource action" do
    expected_embeds =
      """

        embed_templates "read/*"
        embed_templates "new/*"
        embed_templates "edit/*"
        embed_templates "list/*"
      """
      |> String.trim_trailing()

    assert ModuleAPI.build_embeded_templates() == expected_embeds
  end
end
