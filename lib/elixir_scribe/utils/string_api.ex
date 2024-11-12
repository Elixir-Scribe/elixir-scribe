defmodule ElixirScribe.Utils.StringAPI do
  @moduledoc false

  alias ElixirScribe.Utils.String.Capitalize.CapitalizeString
  alias ElixirScribe.Utils.String.HumanCapitalize.HumanCapitalizeString
  alias ElixirScribe.Utils.String.FirstWord.FirstWordString

  def capitalize(string) when is_binary(string), do: CapitalizeString.capitalize(string)

  def capitalize(string, joiner) when is_binary(string) and is_binary(joiner),
    do: CapitalizeString.capitalize(string, joiner)

  def human_capitalize(string) when is_binary(string),
    do: HumanCapitalizeString.capitalize(string)

  def first_word(string) when is_binary(string),
    do: FirstWordString.first(string)

  def first_word(string, word_separators) when is_binary(string) when is_list(word_separators),
    do: FirstWordString.first(string, word_separators)
end
