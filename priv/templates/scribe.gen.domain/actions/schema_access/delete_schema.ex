  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
  alias <%= inspect contract.schema.module %>API

  def <%= action_first_word %>(uuid) when is_binary(uuid) do
    uuid
    |> <%= inspect(contract.schema.alias) %>API.<%= read_action %>!()
    |> Repo.delete()
  end
