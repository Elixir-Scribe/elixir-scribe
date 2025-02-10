
  @doc """
  Returns an `%Ecto.Changeset{}` with a default `%<%= inspect contract.schema.alias %>{}` for tracking <%= contract.schema.singular %> changes.

  ## Examples

      iex> <%= inspect contract.schema.alias %>API.<%= action %>()
      %Ecto.Changeset{data: %<%= inspect contract.schema.alias %>{}}

  """
  def <%= action %>(attrs \\ %{}) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
