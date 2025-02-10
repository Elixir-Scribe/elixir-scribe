defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  import <%= inspect contract.schema.module %>Fixtures

  @update_attrs <%= Mix.Phoenix.to_text contract.schema.params.update %>
  @invalid_attrs <%= Mix.Phoenix.to_text (for {key, _} <- contract.schema.params.create, into: %{}, do: {key, nil}) %>

  setup do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    %{<%= contract.schema.singular %>: <%= contract.schema.singular %>}
  end

  test "<%= action %> <%= contract.schema.singular %> redirects when data is valid", %{conn: conn, <%= contract.schema.singular %>: <%= contract.schema.singular %>} do
    conn = put(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}", <%= contract.schema.singular %>: @update_attrs)
    assert redirected_to(conn) == ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}"

    conn = get(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}")<%= if contract.schema.string_attr do %>
    assert html_response(conn, 200) =~ <%= inspect ElixirScribe.Generator.SchemaResourceAPI.default_param_value(contract.schema, :update) %><% else %>
    assert html_response(conn, 200)<% end %>
  end

  test "renders errors when data is invalid", %{conn: conn, <%= contract.schema.singular %>: <%= contract.schema.singular %>} do
    conn = put(conn, ~p"<%= contract.schema.route_prefix %>/#{<%= contract.schema.singular %>}", <%= contract.schema.singular %>: @invalid_attrs)
    assert html_response(conn, 200) =~ "<%= edit_action_capitalized %> <%= contract.schema.human_singular %>"
    end
end
