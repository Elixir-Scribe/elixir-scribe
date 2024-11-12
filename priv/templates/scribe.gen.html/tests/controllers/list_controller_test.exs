defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  import <%= contract.schema.module %>Fixtures

  setup do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    %{<%= contract.schema.singular %>: <%= contract.schema.singular %>}
  end

  test "lists all <%= contract.schema.plural %>", %{conn: conn} do
    conn = get(conn, ~p"<%= contract.schema.route_prefix %>")
    assert html_response(conn, 200) =~ "Listing <%= contract.schema.human_plural %>"
  end
end
