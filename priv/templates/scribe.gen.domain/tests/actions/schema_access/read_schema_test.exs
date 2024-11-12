  alias <%= absolute_module_action_name %>

  import <%= contract.schema.module %>Fixtures

  test "<%= action_first_word %>!/1 returns the <%= contract.schema.singular %> with given id" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    assert <%= action_capitalized %><%= contract.schema.human_singular <> "." <> action_first_word %>!(<%= contract.schema.singular %>.id) == <%= contract.schema.singular %>
  end
