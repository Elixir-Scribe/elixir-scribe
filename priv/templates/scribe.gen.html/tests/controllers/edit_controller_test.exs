defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  import <%= inspect contract.schema.module %>Fixtures

  setup do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    %{<%= contract.schema.singular %>: <%= contract.schema.singular %>}
  end

  test "<%= action %> <%= contract.schema.singular %> renders form for editing chosen <%= contract.schema.singular %>", %{conn: conn, <%= contract.schema.singular %>: <%= contract.schema.singular %>} do
    conn = get(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}/<%= action %>")
    assert html_response(conn, 200) =~ "<%= edit_action_capitalized %> <%= contract.schema.human_singular %>"
    end
end
