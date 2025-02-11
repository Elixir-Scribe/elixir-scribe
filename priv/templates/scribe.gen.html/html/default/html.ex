defmodule <%= inspect contract.web_module %>.<%= inspect Module.concat(contract.schema.web_namespace, contract.schema.alias) %>HTML do
  use <%= inspect contract.web_module %>, :html
  <%= embeded_templates %>
  embed_templates "<%= contract.schema.singular %>_form.html"

  @doc """
  Renders a <%= contract.schema.singular %> form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def <%= contract.schema.singular %>_form(assigns)
end
