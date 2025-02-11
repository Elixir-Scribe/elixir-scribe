Code.require_file("../../mix_test_helper.exs", __DIR__)

defmodule ElixirScribe.Generator.DomainResourceAPISyncTest do
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.DomainResourceAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  setup do
    Mix.Task.clear()
    :ok
  end

  # Check the ASYNC tests for `generate_actions/1` at test/elixir_scribe/generator/domain_resource_api_async_test.exs
  describe "generate_actions/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (%DomainContract{})",
         config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = DomainResourceAPI.generate_actions(domain_contract)
      end)
    end
  end

  # Check the ASYNC tests for `generate_tests/1` at test/elixir_scribe/generator/domain_resource_api_async_test.exs
  describe "generate_tests/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (%DomainContract{})",
         config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = DomainResourceAPI.generate_tests(domain_contract)
      end)
    end
  end

  # Check the ASYNC tests for `generate_api/1` at test/elixir_scribe/generator/domain_resource_api_async_test.exs
  describe "generate_api/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (%DomainContract{})",
         config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = DomainResourceAPI.generate_api(domain_contract)
      end)
    end
  end

  # Check the ASYNC tests for `generate_test_fixture/1` at test/elixir_scribe/generator/domain_resource_api_async_test.exs
  describe "generate_test_fixture/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (%DomainContract{})",
         config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = DomainResourceAPI.generate_test_fixture(domain_contract)
      end)
    end
  end

  # Check the ASYNC tests for `generate_new_files/1` at test/elixir_scribe/generator/domain_resource_api_async_test.exs
  describe "generate_new_files/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (%DomainContract{})",
         config do
      in_tmp_project(config.test, fn ->
        domain_contract = domain_contract_fixture()

        assert %DomainContract{} = DomainResourceAPI.generate_new_files(domain_contract)
      end)
    end
  end
end
