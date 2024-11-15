  alias <%= absolute_module_action_name %>

  import <%= contract.schema.module %>Fixtures

  test "<%= action_first_word %>/1 returns a <%= contract.schema.singular %> changeset" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    assert %Ecto.Changeset{} = <%= action_capitalized %><%= inspect(contract.schema.alias) %>.<%= action_first_word %>(<%= contract.schema.singular %>.id)
  end
