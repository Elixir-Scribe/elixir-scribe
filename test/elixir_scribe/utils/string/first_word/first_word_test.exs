defmodule ElixirScribe.Utils.String.FirstWord.FirstWordStringTest do
  use ExUnit.Case

  alias ElixirScribe.Utils.StringAPI

  describe "first_word/2" do
    test "returns first word in a string with more then one word" do
      assert "This is a string" |> StringAPI.first_word() === "This"
    end

    test "returns the same string when it only has one word" do
      assert "string" |> StringAPI.first_word() === "string"
    end

    test "returns an empty string when an empty string is given" do
      assert "" |> StringAPI.first_word() === ""
    end

    test "returns an empty string when a string with white spaces is given" do
      assert " " |> StringAPI.first_word() === ""
    end

    test "returns the first word in a string when word separators are given as the second argument" do
      assert "This|is a string" |> StringAPI.first_word(["|"]) === "This"
    end
  end
end
