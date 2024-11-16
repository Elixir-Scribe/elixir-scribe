defmodule ElixirScribe.Utils.StringAPI do
  @moduledoc false

  alias ElixirScribe.Utils.String.Capitalize.CapitalizeString
  alias ElixirScribe.Utils.String.HumanCapitalize.HumanCapitalizeString
  alias ElixirScribe.Utils.String.FirstWord.FirstWordString
  alias ElixirScribe.Utils.String.CamelCaseToSentence

  def capitalize(string) when is_binary(string), do: CapitalizeString.capitalize(string)

  def capitalize(string, joiner) when is_binary(string) and is_binary(joiner),
    do: CapitalizeString.capitalize(string, joiner)

  def human_capitalize(string) when is_binary(string),
    do: HumanCapitalizeString.capitalize(string)

  def first_word(string) when is_binary(string),
    do: FirstWordString.first(string)

  def first_word(string, word_separators) when is_binary(string) when is_list(word_separators),
    do: FirstWordString.first(string, word_separators)

  def camel_case_to_sentence(camel_case_word) when is_binary(camel_case_word) and byte_size(camel_case_word) > 0, do: CamelCaseToSentence.convert(camel_case_word)

  def camel_case_to_sentence(camel_case_word, modifier) when is_binary(camel_case_word) and byte_size(camel_case_word) > 0 and is_atom(modifier), do: CamelCaseToSentence.convert(camel_case_word)
end
