defmodule ElixirScribe.Utils.String.FindAcronyms do
  @doc """
  Finds acronyms in a string. An acronym is defined as two or more consecutive uppercase letters.

  ## Examples

      iex> FindAcronyms.find("HTTPRequestHandler is a BooksAPI example")
      ["HTTP", "API"]

      iex> FindAcronyms.find("The ParseISBNHandler is an example")
      ["ISBN"]

      iex> FindAcronyms.find("JSONParser from file_OCAID")
      ["JSON", "OCAID"]

      iex> FindAcronyms.find("Find all TAR files from SQL_dumps dir")
      ["TAR", "SQL"]

      iex> FindAcronyms.find("Find all TXT files from dir some/JSON/folder")
      ["TXT", "JSON"]

      iex> FindAcronyms.find("This is a test with no acronyms")
      []
  """
  def find(string) when is_binary(string) and byte_size(string) > 0 do
    # Regex to match two or more uppercase letters not followed by a lowercase letter
    ~r/[A-Z]{2,}(?=[^a-z]|$)/
    |> Regex.scan(string)
    |> List.flatten()
  end
  def find(_string), do: []
end
