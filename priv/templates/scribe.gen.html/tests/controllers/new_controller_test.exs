defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  test "<%= action %> <%= contract.schema.singular %> renders form", %{conn: conn} do
    conn = get(conn, ~p"<%= contract.schema.route_prefix %>/<%= action %>")
    assert html_response(conn, 200) =~ "<%= action_capitalized %> <%= contract.schema.human_singular %>"
  end
end
