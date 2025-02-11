defmodule ElixirScribe.MixAPITest do
  alias ElixirScribe.MixAPI
  use ElixirScribe.BaseCase, async: true

  # @INFO: Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "parse_cli_command/1" do
    test "can be invoked with the correct argument type (list) and returns the expected type ({list, list, list})" do
      assert {parsed_args, opts, invalid_args} = MixAPI.parse_cli_command([])
      assert is_list(parsed_args)
      assert is_list(opts)
      assert is_list(invalid_args)
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        MixAPI.parse_cli_command(%{})
      end
    end
  end
end
