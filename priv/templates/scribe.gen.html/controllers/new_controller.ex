defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect contract.web_module %>, :controller

  alias <%= inspect contract.schema.module %>API

  plug :put_view, html: <%= inspect contract.web_module %>.<%= contract.schema.web_namespace %>.<%= inspect contract.schema.alias %>HTML

  def <%= action %>(conn, _params) do
    changeset = <%= inspect(contract.schema.alias) %>API.<%= action %>()
    render(conn, "<%= action %>_<%= contract.schema.singular %>.html", changeset: changeset)
  end
end
