  alias <%= inspect contract.schema.module %>

  @doc false
  def <%= action_first_word %>(attrs \\ %{}) when is_map(attrs) do
    <%= inspect contract.schema.alias %>.changeset(%<%= contract.schema.human_singular %>{}, attrs)
  end
