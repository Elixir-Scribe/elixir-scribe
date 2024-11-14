defmodule <%= absolute_module_action_name %>Controller do
  use <%= inspect contract.web_module %>, :controller

  alias <%= inspect contract.schema.module %>API

  plug :put_view, html: <%= inspect contract.web_module %>.<%= contract.schema.web_namespace %>.<%= inspect contract.schema.alias %>HTML

  def <%= action %>(conn, %{<%= inspect contract.schema.singular %> => <%= contract.schema.singular %>_params}) do
    case <%= contract.schema.human_singular %>API.<%= action %>(<%= contract.schema.singular %>_params) do
      {:ok, <%= contract.schema.singular %>} ->
        conn
        |> put_flash(:info, "<%= contract.schema.human_singular %> created successfully.")
        |> redirect(to: ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "<%= new_action %>_<%= contract.schema.singular %>.html", changeset: changeset)
    end
  end
end
