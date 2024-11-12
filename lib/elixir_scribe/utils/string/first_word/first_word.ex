defmodule ElixirScribe.Utils.String.FirstWord.FirstWordString do
  @moduledoc false

  @doc false
  def first(string, word_separators \\ ["_", "-", " "])
      when is_binary(string) and is_list(word_separators) do
    string
    |> String.split(word_separators)
    |> List.first()
  end
end
