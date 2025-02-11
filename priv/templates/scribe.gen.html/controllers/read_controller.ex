defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect contract.web_module %>, :controller

  alias <%= inspect contract.schema.module %>API

  plug :put_view, html: <%= inspect contract.web_module %>.<%= contract.schema.web_namespace %>.<%= inspect contract.schema.alias %>HTML

  def <%= action %>(conn, %{"id" => id}) do
    <%= contract.schema.singular %> = <%= inspect(contract.schema.alias) %>API.<%= action %>!(id)
    render(conn, "<%= action %>_<%= contract.schema.singular %>.html", <%= contract.schema.singular %>: <%= contract.schema.singular %>)
  end
end
