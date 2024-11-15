  alias <%= absolute_module_action_name %>

  import <%= contract.schema.module %>Fixtures

  test "<%= action_first_word %>/0 returns all <%= contract.schema.plural %>" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    assert <%= action_capitalized <> inspect(contract.schema.alias_plural) <> "." <> action_first_word %>() == [<%= contract.schema.singular %>]
  end
