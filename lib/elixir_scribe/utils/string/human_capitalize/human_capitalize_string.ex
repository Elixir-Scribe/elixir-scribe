defmodule ElixirScribe.Utils.String.HumanCapitalize.HumanCapitalizeString do
  @moduledoc false

  alias ElixirScribe.Utils.StringAPI

  def capitalize(string) when is_binary(string) do
    joiner = " "

    string
    |> StringAPI.capitalize(joiner)
  end
end
