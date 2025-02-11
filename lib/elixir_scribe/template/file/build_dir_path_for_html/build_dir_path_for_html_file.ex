defmodule ElixirScribe.Template.File.BuildPathForHtml.BuildPathForHtmlFile do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract

  def build(%DomainContract{} = contract) do
    template = Keyword.get(contract.opts, :html_template, "default")

    ElixirScribe.html_template_path()
    |> Path.join(template)
  end
end
