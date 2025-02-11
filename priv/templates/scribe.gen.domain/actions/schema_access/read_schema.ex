  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
  alias <%= inspect contract.schema.module %>

  def <%= action_first_word %>!(uuid) when is_binary(uuid), do: Repo.get!(<%= inspect contract.schema.alias %>, uuid)
