
  @doc """
  Deletes the <%= schema.singular %> for the given `uuid`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>("38cd0012-79dc-4838-acc0-94d4143c4f2c")
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= schema.human_singular %>API.<%= action %>("815af9955-19ab-2567-bdd1-49e4143c4g3d")
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(uuid) when is_binary(uuid), do: <%= module_action_name %>.<%= action_first_word %>(uuid)
