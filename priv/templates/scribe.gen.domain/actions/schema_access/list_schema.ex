  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
  alias <%= inspect contract.schema.module %>

  @doc false
  def <%= action_first_word %>() do
    Repo.all(<%= inspect contract.schema.alias %>)
  end
