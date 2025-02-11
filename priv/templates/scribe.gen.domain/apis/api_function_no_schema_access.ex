
  @doc """
  <%= contract.schema.human_singular %>: <%= action_human_capitalized %>.
  """
  def <%= action %>(), do: <%= module_action_name %>.<%= action_first_word %>()
