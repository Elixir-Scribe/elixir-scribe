defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect contract.web_module %>, :controller

  alias <%= inspect contract.schema.module %>API

  plug :put_view, html: <%= inspect contract.web_module %>.<%= contract.schema.web_namespace %>.<%= inspect contract.schema.alias %>HTML

  def <%= action %>(conn, %{"id" => id}) do
    {:ok, _<%= contract.schema.singular %>} = <%= contract.schema.human_singular %>API.<%= action %>(id)

    conn
    |> put_flash(:info, "<%= contract.schema.human_singular %> deleted successfully.")
    |> redirect(to: ~p"<%= contract.schema.route_prefix %>")
  end
end
