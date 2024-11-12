
  @doc """
  Creates a <%= contract.schema.singular %> from the given `attrs`.

  ## Examples

      iex> <%= inspect contract.schema.alias %>API.<%= action %>(%{field: value})
      {:ok, %<%= inspect contract.schema.alias %>{}}

      iex> <%= inspect contract.schema.alias %>API.<%= action %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(attrs) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
