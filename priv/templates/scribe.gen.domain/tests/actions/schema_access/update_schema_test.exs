  alias <%= absolute_module_action_name %>
  alias <%= inspect contract.schema.module %>
  alias <%= inspect contract.schema.module %><%= "." <> read_action_capitalized <> "." <> read_action_capitalized <> inspect(contract.schema.alias) %>

  import <%= contract.schema.module %>Fixtures

  @invalid_attrs <%= Mix.Phoenix.to_text for {key, _} <- contract.schema.params.create, into: %{}, do: {key, nil} %>

  test "<%= action_first_word %>/2 with valid data updates the <%= contract.schema.singular %>" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    update_attrs = <%= Mix.Phoenix.to_text contract.schema.params.update%>

    assert {:ok, %<%= inspect contract.schema.alias %>{} = <%= contract.schema.singular %>} = <%= action_capitalized %><%= inspect(contract.schema.alias) %>.<%= action_first_word %>(<%= contract.schema.singular %>.id, update_attrs)
    <%= for {field, value} <- contract.schema.params.update do %>
    assert <%= contract.schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(contract.schema, field, value) %><% end %>
  end

  test "<%= action_first_word %>/2 with invalid data returns error changeset" do
    <%= contract.schema.singular %> = <%= contract.schema.singular %>_fixture()
    assert {:error, %Ecto.Changeset{}} = <%= action_capitalized %><%= inspect(contract.schema.alias) <> "." <> action_first_word %>(<%= contract.schema.singular %>.id, @invalid_attrs)
    assert <%= contract.schema.singular %> == <%= read_action_capitalized %><%= inspect(contract.schema.alias) <> "." <> read_action %>!(<%= contract.schema.singular %>.id)
  end
