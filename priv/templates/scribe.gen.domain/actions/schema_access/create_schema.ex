  alias <%= inspect contract.schema.repo %><%= contract.schema.repo_alias %>
  alias <%= inspect contract.schema.module %>API

  def <%= action_first_word %>(%{} = attrs) when attrs !== %{} do
    attrs
    |> <%= inspect contract.schema.alias %>API.new()
    |> Repo.insert()
  end
