defmodule ElixirScribe.Utils.StringAPITest do
  alias ElixirScribe.Utils.StringAPI
  use ElixirScribe.BaseCase, async: true

  # INFO: Tests in the API module only care about testing the function can be invoked and that the API contract is respected (for now only guards and pattern matching). The unit tests for the functionality are done in their respective modules

  describe "capitalize/1" do
    test "can be invoked and returns a string" do
      assert StringAPI.capitalize("whatever") |> is_binary()
    end

    test "raises a FunctionClauseError when the argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.capitalize(123)
      end
    end
  end

  describe "capitalize/2" do
    test "can be invoked and returns a string" do
      assert StringAPI.capitalize("whatever word", "") |> is_binary()
    end

    test "raises a FunctionClauseError when the first arguments isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.capitalize(:whatever, "")
      end
    end

    test "raises a FunctionClauseError when the joiner (2nd arg) isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.capitalize("whatever word", :bad_joiner)
      end
    end
  end

  describe "human_capitalize/1" do
    test "can be invoked and returns a string" do
      assert StringAPI.capitalize("whatever word") |> is_binary()
    end

    test "raises a FunctionClauseError when the argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.capitalize(:whatever)
      end
    end
  end

  describe "first_word/1" do
    test "can be invoked and returns a string" do
      assert StringAPI.first_word("whatever word") |> is_binary()
    end

    test "raises a FunctionClauseError when the argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.first_word(:whatever)
      end
    end
  end

  describe "first_word/2" do
    test "can be invoked and returns a string" do
      assert StringAPI.first_word("whatever_word") |> is_binary()
    end

    test "raises a FunctionClauseError when the first argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.first_word(:whatever_word)
      end
    end

    test "raises a FunctionClauseError when the second argument (word_separators) isn't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        StringAPI.first_word(:whatever_word, "")
      end
    end
  end
end
