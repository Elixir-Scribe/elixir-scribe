defmodule ElixirScribe.TemplateFileAPIAsyncTest do
  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Template.FileAPI
  use ElixirScribe.BaseCase, async: true

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  describe "build_dir_path_for_html_file/1" do
    test "can be invoked with the correct argument type (%DomainContract{}) and returns the expected type (string)" do
      contract = domain_contract_fixture()

      assert FileAPI.build_dir_path_for_html_file(contract) |> is_binary()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%DomainContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.build_dir_path_for_html_file(%{})
      end
    end
  end

  describe "build_template_action_filename/1" do
    test "can be invoked with the correct argument type (%BuildFilenameForActionFileContract{}) and returns the expected type (string)" do
      attrs = %{
        action: "read",
        action_suffix: "_",
        file_type: "schema",
        file_extension: ".ex"
      }

      contract = BuildFilenameForActionFileContract.new!(attrs)

      assert FileAPI.build_template_action_filename(contract) |> is_binary()
    end

    test "raises a FunctionClauseError when isn't invoked with the correct argument type (%BuildFilenameForActionFileContract{})" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.build_template_action_filename(%{})
      end
    end
  end

  # Check the SYNC tests at test/elixir_scribe/template/template_binding_api_sync_test.exs
  describe "inject_content_before_module_end/2" do
    test "raises a FunctionClauseError when the first argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_content_before_module_end(["whatever"], "api.ex")
      end
    end

    test "raises a FunctionClauseError when the second argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_content_before_module_end("whatever", ["api.ex"])
      end
    end
  end

  describe "inject_eex_template_before_module_end/4" do
    test "raises a FunctionClauseError when the first argument isn't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_eex_template_before_module_end(%{}, "source.ex", "target.ex", [])
      end
    end

    test "raises a FunctionClauseError when the second argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_eex_template_before_module_end([], ["source.ex"], "target.ex", [])
      end
    end

    test "raises a FunctionClauseError when the third argument isn't a string" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_eex_template_before_module_end([], "source.ex", ["target.ex"], [])
      end
    end

    test "raises a FunctionClauseError when the fourth argument isn't a list" do
      assert_raise FunctionClauseError, ~r/^no function clause matching in.*$/s, fn ->
        FileAPI.inject_eex_template_before_module_end([], "source.ex", "target.ex", "")
      end
    end
  end
end
