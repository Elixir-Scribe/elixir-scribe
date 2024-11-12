defmodule <%= absolute_module_action_name %>ControllerTest do
  use <%= inspect contract.web_module %>.ConnCase

  test "<%= action %> <%= contract.schema.singular %>", %{conn: _conn} do
    raise "Test not implemented yet..."
  end
end
