  alias <%= absolute_module_action_name %>

  test "<%= action_first_word %>/0 returns a <%= contract.schema.singular %> changeset" do
    assert %Ecto.Changeset{} = <%= action_capitalized %><%= inspect(contract.schema.alias) %>.<%= action_first_word %>()
  end
