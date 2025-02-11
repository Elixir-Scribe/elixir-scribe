  alias <%= inspect contract.schema.module %>API

<%= for {attr, {_function_name, function_def, _needs_impl?}} <- contract.schema.fixture_unique_functions do %>  @doc """
  Generate a unique <%= contract.schema.singular %> <%= attr %>.
  """
<%= function_def %>
<% end %>  @doc """
  Generate a <%= contract.schema.singular %>.
  """
  def <%= contract.schema.singular %>_fixture(attrs \\ %{}) do
    {:ok, <%= contract.schema.singular %>} =
      attrs
      |> Enum.into(%{
<%= contract.schema.fixture_params |> Enum.map(fn {key, code} -> "        #{key}: #{code}" end) |> Enum.join(",\n") %>
      })
      |> <%= inspect(contract.schema.alias) <> "API." <> create_action %>()

    <%= contract.schema.singular %>
  end
