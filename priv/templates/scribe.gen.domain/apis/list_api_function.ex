
  @doc """
  Returns the list of <%= contract.schema.plural %>.

  ## Examples

      iex> <%=inspect contract.schema.alias %>API.<%= action %>()
      [%<%= inspect contract.schema.alias %>{}, ...]

  """
  def <%= action %>(), do: <%= module_action_name %>.<%= action_first_word %>()
