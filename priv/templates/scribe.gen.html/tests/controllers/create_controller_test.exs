defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  @create_attrs <%= Mix.Phoenix.to_text contract.schema.params.create %>
  @invalid_attrs <%= Mix.Phoenix.to_text (for {key, _} <- contract.schema.params.create, into: %{}, do: {key, nil}) %>

  test "<%= action %> <%= contract.schema.singular %> redirects to show when data is valid", %{conn: conn} do
    conn = post(conn, ~p"<%= contract.schema.route_prefix %>", <%= contract.schema.singular %>: @create_attrs)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == ~p"<%= contract.schema.route_prefix %>/#{id}"

    conn = get(conn, ~p"<%= contract.schema.route_prefix %>/#{id}")
    assert html_response(conn, 200) =~ "<%= contract.schema.human_singular %> #{id}"
  end

  test "<%= action %> <%= contract.schema.singular %> renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, ~p"<%= contract.schema.route_prefix %>", <%= contract.schema.singular %>: @invalid_attrs)
    assert html_response(conn, 200) =~ "<%= new_action_capitalized %> <%= contract.schema.human_singular %>"
  end
end
