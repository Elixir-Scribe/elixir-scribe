defmodule <%= absolute_module_action_name %>Test do
  use <%= inspect contract.base_module %>.DataCase

  alias <%= module_action_name %>

  test "<%= action_first_word %> works as expected" do
    raise "TODO: Implement test for action `<%= action_first_word %>` at `<%= module_action_name %>`"
  end
end
