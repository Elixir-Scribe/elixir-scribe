defmodule ElixirScribe.Utils.String.HumanCapitalize.HumanCapitalizeStringTest do
  use ExUnit.Case

  alias ElixirScribe.Utils.StringAPI

  describe "human_capitalize/1" do
    test "capitalizes a string to be human readable" do
      assert " string " |> StringAPI.human_capitalize() === "String"
    end

    test "capitalizes a snake_case string to be human readable" do
      assert "some_string" |> StringAPI.human_capitalize() === "Some String"
    end

    test "capitalizes a kebab-case string to be human readable" do
      assert "some-string" |> StringAPI.human_capitalize() === "Some String"
    end
  end
end
