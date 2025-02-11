defmodule ElixirScribe.Utils.String.CamelCaseToSentence do
  @moduledoc false

  # Regex Components:
  # * (?<=[A-Z])(?=[A-Z][a-z]) - Matches a position after an uppercase letter
  #   and  before a sequence of an uppercase letter followed by a lowercase
  #   letter. Example: In "ISBNFiles", this matches between "ISBN" and "Files".
  # * (?<=[a-z])(?=[A-Z]) - Matches a position after a lowercase letter and
  #   before an uppercase letter. Example: In "MySuperVariable", this matches
  #   between "My" and "Super".

  @doc """
  Converts a camel case word to a capitalized sentence and preserves acronyms.

      ## Examples
          iex> CamelCaseToSentence.convert("ISBNFiles", :capitalized)
          "ISBN Files"

          iex> CamelCaseToSentence.convert("CamelCaseToSentence", :capitalized)
          "Camel Case To Sentence"

          iex> CamelCaseToSentence.convert("ABCD", :capitalized)
          "ABCD"
  """
  def convert(camel_case_word, :capitalized)
      when is_binary(camel_case_word) and byte_size(camel_case_word) > 0 do
    camel_case_word
    |> String.replace(~r/(?<=[A-Z])(?=[A-Z][a-z])|(?<=[a-z])(?=[A-Z])/, " ")
  end

  @doc """
  Translates a camel case word into a sentence, preserving acronyms, with only
  the first word capitalized.

  ## Examples

      iex> CamelCaseToSentence.convert("HTTPRequestURLParser")
      "HTTP request URL parser"

      iex> CamelCaseToSentence.convert("XMLToJSON")
      "XML to JSON"

      iex> CamelCaseToSentence.convert("JSONAPIHandler")
      "JSONAPI handler"

      iex> CamelCaseToSentence.convert("SimpleExample")
      "Simple example"
  """
  def convert(camel_case_word)
      when is_binary(camel_case_word) and byte_size(camel_case_word) > 0 do
    camel_case_word
    |> split_camel_case_into_words()
    |> format_words()
    |> Enum.join(" ")
  end

  defp split_camel_case_into_words(word) do
    # Regular expression for splitting camel case while preserving acronyms
    regex = ~r/(?<=[a-z])(?=[A-Z])|(?<=[A-Z]{2})(?=[A-Z][a-z])/

    String.split(word, regex)
  end

  defp format_words(words) do
    words
    |> Enum.with_index()
    |> Enum.map(fn
      {first_word, 0} -> capitalize_sentence_first_word(first_word)
      {remaining_words, _} -> downcase_rest_of_sentence(remaining_words)
    end)
  end

  defp capitalize_sentence_first_word(word) do
    if acronym?(word), do: word, else: String.capitalize(word)
  end

  defp downcase_rest_of_sentence(word) do
    if acronym?(word), do: word, else: String.downcase(word)
  end

  defp acronym?(word) do
    String.upcase(word) == word
  end
end
