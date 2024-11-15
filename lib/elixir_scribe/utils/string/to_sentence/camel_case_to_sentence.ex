defmodule ElixirScribe.Utils.String.CamelCaseToSentence do
  @moduledoc """
  Converts a camel case word to a sentence by adding spaces before transitions from capital letters to lowercase letters, or between sequences of capital letters followed by lowercase letters.

  ## Examples
      iex> CamelCaseToSentence.convert("ISBNFiles")
      "ISBN Files"

      iex> CamelCaseToSentence.convert("MySuperVariable")
      "My Super Variable"

      iex> CamelCaseToSentence.convert("CamelCaseToSentence")
      "Camel Case To Sentence"

      iex> CamelCaseToSentence.convert("ABCD")
      "ABCD"
  """

  # Regex Components:
  # * (?<=[A-Z])(?=[A-Z][a-z]) - Matches a position after an uppercase letter
  #   and  before a sequence of an uppercase letter followed by a lowercase
  #   letter. Example: In "ISBNFiles", this matches between "ISBN" and "Files".
  # * (?<=[a-z])(?=[A-Z]) - Matches a position after a lowercase letter and
  #   before an uppercase letter. Example: In "MySuperVariable", this matches
  #   between "My" and "Super".
  def convert(camel_case) do
    camel_case
    |> String.replace(~r/(?<=[A-Z])(?=[A-Z][a-z])|(?<=[a-z])(?=[A-Z])/, " ")
  end
end
