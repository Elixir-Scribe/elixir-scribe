defmodule ElixirScribe.Utils.String.Capitalize.CapitalizeStringTest do
  use ExUnit.Case

  alias ElixirScribe.Utils.StringAPI

  describe "capitalize/1" do
    test "capitalizes a string" do
      assert " string " |> StringAPI.capitalize() === "String"
    end

    test "capitalizes a snake_case string" do
      assert "some_string" |> StringAPI.capitalize() === "SomeString"
    end

    test "capitalizes a kebab-case string" do
      assert "some-string" |> StringAPI.capitalize() === "SomeString"
    end
  end

  describe "capitalize/2" do
    test "capitalizes a string with the given joiner" do
      joiner = " "

      assert "some-string" |> StringAPI.capitalize(joiner) === "Some String"
    end
  end
end
