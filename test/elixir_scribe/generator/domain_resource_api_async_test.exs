defmodule ElixirScribe.Generator.DomainResourceAPIAsyncTest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.DomainResourceAPI
  use ElixirScribe.BaseCase, async: true

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "build_domain_resource_contract/2" do
    test "can be invoked with the correct arguments types (list, list) and returns the expected tuple ({:ok, %DomainContract{}})" do
      args = ["Blog", "Post", "posts", "title:string", "desc:string"]
      {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

      assert {:ok, %DomainContract{}} =
               DomainResourceAPI.build_domain_resource_contract(valid_args, opts)
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.build_domain_resource_contract(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.build_domain_resource_contract([], %{})
      end
    end
  end

  describe "build_files_to_generate/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (list)" do
      domain_contract = domain_contract_fixture()

      assert DomainResourceAPI.build_files_to_generate(domain_contract) |> is_list()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.build_files_to_generate(%{})
      end
    end
  end

  describe "build_action_files_paths/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (list)" do
      domain_contract = domain_contract_fixture()

      assert DomainResourceAPI.build_action_files_paths(domain_contract) |> is_list()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.build_action_files_paths(%{})
      end
    end
  end

  describe "build_test_action_files_paths/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (list)" do
      domain_contract = domain_contract_fixture()

      assert DomainResourceAPI.build_test_action_files_paths(domain_contract) |> is_list()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.build_test_action_files_paths(%{})
      end
    end
  end

  # The SYNC tests for `generate_actions/1` at test/elixir_scribe/generator/domain_resource_api_sync_test.exs
  describe "generate_actions/1" do
    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.generate_actions(%{})
      end
    end
  end

  # The SYNC tests for `generate_tests/1` at test/elixir_scribe/generator/domain_resource_api_sync_test.exs
  describe "generate_tests/1" do
    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.generate_tests(%{})
      end
    end
  end

  # The SYNC tests for `generate_api/1` at test/elixir_scribe/generator/domain_resource_api_sync_test.exs
  describe "generate_api/1" do
    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.generate_api(%{})
      end
    end
  end

  # The SYNC tests for `generate_test_fixture/1` at test/elixir_scribe/generator/domain_resource_api_sync_test.exs
  describe "generate_test_fixture/1" do
    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.generate_test_fixture(%{})
      end
    end
  end

  # The SYNC tests for `generate_new_files/1` at test/elixir_scribe/generator/domain_resource_api_sync_test.exs
  describe "generate_new_files/1" do
    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        DomainResourceAPI.generate_new_files(%{})
      end
    end
  end
end
