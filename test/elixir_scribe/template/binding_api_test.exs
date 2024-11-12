defmodule ElixirScribe.Template.BindingAPITest do
  alias ElixirScribe.Template.BindingAPI
  use ElixirScribe.BaseCase, async: true

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "build_binding_template/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (list)" do
      contract = domain_contract_fixture()

      assert BindingAPI.build_binding_template(contract) |> is_list()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        BindingAPI.build_binding_template(%{})
      end
    end
  end

  describe "rebuild_binding_template/1" do
    test "can be invoked with the correct arguments type (list, string, list) and returns the expected type (list)" do
      contract = domain_contract_fixture()

      binding = BindingAPI.build_binding_template(contract)

      assert BindingAPI.rebuild_binding_template(
               binding,
               "whatever_action",
               file_type: :lib_core
             )
             |> is_list()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        BindingAPI.rebuild_binding_template(%{}, "", [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        BindingAPI.rebuild_binding_template([], 1, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct third argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        BindingAPI.rebuild_binding_template([], "", %{})
      end
    end
  end
end
