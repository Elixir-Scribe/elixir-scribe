  alias <%= absolute_module_action_name %>
  alias <%= inspect contract.schema.module %>

  @invalid_attrs <%= Mix.Phoenix.to_text for {key, _} <- contract.schema.params.create, into: %{}, do: {key, nil} %>

  test "<%= action_first_word %>/1 with valid data creates a <%= contract.schema.singular %>" do
    valid_attrs = <%= Mix.Phoenix.to_text contract.schema.params.create %>

    assert {:ok, %<%= inspect contract.schema.alias %>{} = <%= contract.schema.singular %>} = <%= action_capitalized %><%= contract.schema.human_singular %>.<%= action_first_word %>(valid_attrs)
    <%= for {field, value} <- contract.schema.params.create do %>
    assert <%= contract.schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(contract.schema, field, value) %><% end %>
  end

  test "<%= action_first_word %>/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = <%= action_capitalized %><%= contract.schema.human_singular %>.<%= action_first_word %>(@invalid_attrs)
  end
