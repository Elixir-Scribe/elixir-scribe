defmodule ElixirScribe.Template.ModuleAPITest do
  alias ElixirScribe.Template.ModuleAPI
  use ElixirScribe.BaseCase, async: true

  describe "build_embeded_templates/0" do
    test "can be invoked and returns the expected type (string)" do
      assert ModuleAPI.build_embeded_templates() |> is_binary()
    end
  end

  describe "build_absolute_module_action_name/3" do
    test "can be invoked with the correct arguments type (%DomainContract{}, string, list) and returns the expected type (string)" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_action_name(contract, "read", file_type: :lib_core)
             |> is_binary()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_absolute_module_action_name(%{}, "action", [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_absolute_module_action_name(%{}, ["action"], [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct third argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_absolute_module_action_name(%{}, "action", "")
      end
    end
  end

  describe "build_absolute_module_action_name_aliases/2" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (string)" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_action_name_aliases(contract, file_type: :lib_core)
             |> is_binary()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_absolute_module_action_name_aliases(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        domain_contract_fixture()
        |> ModuleAPI.build_absolute_module_action_name_aliases(%{})
      end
    end
  end

  describe "build_absolute_module_name/2" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (atom)" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :lib_core) |> is_atom()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_absolute_module_name(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        domain_contract_fixture()
        |> ModuleAPI.build_absolute_module_name("")
      end
    end
  end

  describe "build_module_action_name/2" do
    test "can be invoked with the correct arguments type (%DomainContract{}, string) and returns the expected type (string)" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_module_action_name(contract, "action") |> is_binary()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        ModuleAPI.build_module_action_name(%{}, "action")
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        domain_contract_fixture()
        |> ModuleAPI.build_module_action_name(:whatever)
      end
    end
  end
end
