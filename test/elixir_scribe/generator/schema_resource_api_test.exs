defmodule ElixirScribe.Generator.SchemaResourceAPITest do
  alias ElixirScribe.MixAPI
  alias ElixirScribe.Generator.SchemaResourceAPI
  alias ElixirScribe.Generator.SchemaContract
  use ElixirScribe.BaseCase, async: true

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "build_schema_resource_contract/2" do
    test "can be invoked with the correct arguments types (list, list) and returns the expected tuple ({:ok, %SchemaContract{}})" do
      args = ["Blog", "Post", "posts", "title:string", "desc:string"]

      {valid_args, opts, _invalid_args} = args |> MixAPI.parse_cli_command()

      assert {:ok, %SchemaContract{} = contract} =
               SchemaResourceAPI.build_schema_resource_contract(valid_args, opts)

      assert ^contract = SchemaResourceAPI.build_schema_resource_contract!(valid_args, opts)
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        SchemaResourceAPI.build_schema_resource_contract(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (list)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        SchemaResourceAPI.build_schema_resource_contract([], %{})
      end
    end
  end

  describe "default_param_value/2" do
    test "can be invoked with the correct arguments types (%SchemaContract{}, atom) and returns the expected string" do
      contract = domain_contract_fixture()

      assert SchemaResourceAPI.default_param_value(contract.schema, :create) === "some name"
    end

    test "raises a FunctionClauseError when isn't invoked with the correct first argument type (%SchemaContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        SchemaResourceAPI.default_param_value(%{}, [])
      end
    end

    test "raises a FunctionClauseError when isn't invoked with the correct second argument type (atom)" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        contract = domain_contract_fixture()
        SchemaResourceAPI.default_param_value(contract, [])
      end
    end
  end

  describe "live_form_value/2" do
    test "can be invoked with the correct first argument type (%Date{}) and returns the expected string format %Y-%m-%d" do
      date = Date.new!(2024, 9, 6)

      assert SchemaResourceAPI.live_form_value(date) === "2024-09-06"
    end

    test "can be invoked with the correct first argument type (%Time{}) and returns the expected string format %H:%M" do
      time = Time.new!(9, 12, 25)

      assert SchemaResourceAPI.live_form_value(time) === "09:12"
    end

    test "can be invoked with the correct first argument type (%DateTime{}) and returns the expected string format %Y-%m-%d %H:%MZ" do
      date = Date.new!(2024, 9, 6)
      time = Time.new!(9, 12, 25)
      datetime = DateTime.new!(date, time)

      assert SchemaResourceAPI.live_form_value(datetime) === "2024-09-06T09:12:25Z"
    end

    test "can be invoked with the correct first argument type (%NaiveDateTime{}) and returns the expected string format %Y-%m-%dT%H:%M" do
      naive_datetime = NaiveDateTime.new!(2024, 9, 6, 9, 12, 25)

      assert SchemaResourceAPI.live_form_value(naive_datetime) === "2024-09-06T09:12:25"
    end

    test "when isn't invoked with the correct first argument type (%Date{}, %Time{}, %DateTime{} or %NaiveDateTime{}) it returns the same unchanged value" do
      assert SchemaResourceAPI.live_form_value("whatever") === "whatever"
    end
  end
end
