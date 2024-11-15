  alias <%= absolute_module_action_name %>
  alias <%= inspect contract.schema.module %>
  alias <%= inspect contract.schema.module %><%= "." <> read_action_capitalized <> "." <> read_action_capitalized <> inspect(contract.schema.alias) %>

  import <%= contract.schema.module %>Fixtures

  test "<%= action_first_word %>/1 deletes the <%= contract.schema.singular %>" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    assert {:ok, %<%= inspect contract.schema.alias %>{}} = <%= action_capitalized %><%= inspect(contract.schema.alias) %>.<%= action_first_word %>(<%= contract.schema.singular %>.id)
    assert_raise Ecto.NoResultsError, fn -> <%= read_action_capitalized %><%= inspect(contract.schema.alias) %>.<%= read_action %>!(<%= contract.schema.singular %>.id) end
  end
