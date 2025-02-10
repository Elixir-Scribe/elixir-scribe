defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  import <%= inspect contract.schema.module %>Fixtures

  setup do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    %{<%= contract.schema.singular %>: <%= contract.schema.singular %>}
  end

  test "deletes chosen <%= contract.schema.singular %>", %{conn: conn, <%= contract.schema.singular %>: <%= contract.schema.singular %>} do
    conn = delete(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}")
    assert redirected_to(conn) == ~p"<%= contract.schema.route_prefix %>"

    assert_error_sent 404, fn ->
      get(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}")
    end
  end
end
