defmodule ElixirScribe.Template.Options.BuildEmbedTemplates.BuildModuleEmbedTemplates do
  @moduledoc false

  def build() do
    for action <- ElixirScribe.resource_html_actions(), reduce: "" do
      embeds -> embeds <> "\n  embed_templates \"#{action}/*\""
    end
  end
end
