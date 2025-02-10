defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect contract.web_module %>, :controller

  alias <%= inspect contract.schema.module %>API

  plug :put_view, html: <%= inspect contract.web_module %>.<%= contract.schema.web_namespace %>.<%= inspect contract.schema.alias %>HTML

  def <%= action %>(conn, _params) do
    <%= contract.schema.plural %> = <%= inspect(contract.schema.alias) %>API.<%= action %>()
    render(conn, "<%= action %>_<%= contract.schema.plural %>.html", <%= contract.schema.collection %>: <%= contract.schema.plural %>)
  end
end
