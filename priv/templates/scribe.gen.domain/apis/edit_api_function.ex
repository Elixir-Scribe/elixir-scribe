
  @doc """
  Returns an `%Ecto.Changeset{}` with a `%<%= inspect contract.schema.alias %>{}` for tracking changes for the given <%= contract.schema.singular %> `uuid`.

  ## Examples

      iex> <%= inspect contract.schema.alias %>API.<%= action %>("38cd0012-79dc-4838-acc0-94d4143c4f2c")
      %Ecto.Changeset{data: %<%= inspect contract.schema.alias %>{id: uuid}}

  """
  def <%= action %>(uuid, attrs \\ %{}) when is_binary(uuid) and is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(uuid, attrs)
