defmodule ElixirScribe.Utils.String.Capitalize.CapitalizeString do
  @moduledoc false

  @doc false
  def capitalize(string, joiner \\ "") when is_binary(string) and is_binary(joiner) do
    string
    |> String.split(["_", "-", " "], trim: true)
    |> Enum.map(fn part -> part |> String.trim() |> :string.titlecase() end)
    |> Enum.join(joiner)
  end
end
