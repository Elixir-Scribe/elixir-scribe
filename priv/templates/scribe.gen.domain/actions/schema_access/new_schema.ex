  alias <%= inspect contract.schema.module %>

  def <%= action_first_word %>(attrs \\ %{}) when is_map(attrs) do
    <%= inspect contract.schema.alias %>.changeset(%<%= inspect contract.schema.alias %>{}, attrs)
  end
