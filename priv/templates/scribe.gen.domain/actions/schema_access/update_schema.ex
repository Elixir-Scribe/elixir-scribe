  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
  alias <%= inspect contract.schema.module %>
  alias <%= inspect contract.schema.module %>API

  def <%= action_first_word %>(uuid, %{} = attrs) when is_binary(uuid) and is_map(attrs) do
    uuid
    |> <%= inspect(contract.schema.alias) %>API.<%= read_action %>!()
    |> <%= inspect(contract.schema.alias) %>.changeset(attrs)
    |> Repo.update()
  end
