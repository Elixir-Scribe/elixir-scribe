Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.TemplateFileAPISyncTest do
  alias ElixirScribe.Template.BindingAPI
  alias ElixirScribe.Template.FileAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  # Tests in the API module only care about testing the function can be invoked and that the API contract is respected for guards, pattern matching and expected return types. The unit tests for the functionality are done in their respective modules.

  # Check the ASYNC tests at test/elixir_scribe/template/template_binding_api_async_test.exs
  describe "inject_content_before_module_end/2" do
    test "can be invoked with the correct arguments types (string, string) and returns the expected atom (:ok) for a successful operation",
         config do
      in_tmp_project(config.test, fn ->
        module_content = """
        defmodule API do
        end
        """

        File.write!("api.ex", module_content)

        content_to_inject = """
        def whatever, do: :whatever
        """

        assert :ok = FileAPI.inject_content_before_module_end(content_to_inject, "api.ex")
      end)
    end

    test "returns the tuple {:noop, reason} for an unsuccessful operation", config do
      in_tmp_project(config.test, fn ->
        module_content = """
        defmodule API do
          def whatever, do: :whatever
        end
        """

        File.write!("api.ex", module_content)

        content_to_inject = """
          def whatever, do: :whatever
        """

        assert {:noop, :content_to_inject_already_exists} =
                 FileAPI.inject_content_before_module_end(content_to_inject, "api.ex")
      end)
    end
  end

  describe "inject_eex_template_before_module_end/4" do
    test "can be invoked with the correct arguments types (list, string, string, list) and returns the expected atom (:ok) for a successful operation",
         config do
      in_tmp_project(config.test, fn ->
        api_content = """
        defmodule API do
        end
        """

        File.write!("api_existing_module.ex", api_content)

        function_template = """
          def <%= action %>(), do: :<%= action %>
        """

        File.write!("api_function_template.ex", function_template)

        base_template_paths = ElixirScribe.base_template_paths()

        binding =
          domain_contract_fixture()
          |> BindingAPI.build_binding_template()
          |> BindingAPI.rebuild_binding_template(
            "read",
            file_type: :lib_core
          )

        assert :ok =
                 FileAPI.inject_eex_template_before_module_end(
                   base_template_paths,
                   "api_function_template.ex",
                   "api_existing_module.ex",
                   binding
                 )
      end)
    end

    test "returns the tuple {:noop, reason} for an unsuccessful operation", config do
      in_tmp_project(config.test, fn ->
        function_template = """
          def <%= action %>(), do: :<%= action %>
        """

        File.write!("api_function_template.ex", function_template)

        expected_api_content = """
        defmodule API do
          def create(), do: :create
        end
        """

        File.write!("api_existing_module.ex", expected_api_content)

        base_template_paths = ElixirScribe.base_template_paths()

        binding =
          domain_contract_fixture()
          |> BindingAPI.build_binding_template()
          |> BindingAPI.rebuild_binding_template("create",
            file_type: :lib_core
          )

        assert {:noop, :content_to_inject_already_exists} =
                 FileAPI.inject_eex_template_before_module_end(
                   base_template_paths,
                   "api_function_template.ex",
                   "api_existing_module.ex",
                   binding
                 )
      end)
    end
  end
end
