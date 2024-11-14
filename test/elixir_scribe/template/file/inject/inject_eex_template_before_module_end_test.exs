Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Template.File.Inject.InjectEExTemplateBeforeModuleEndTest do
  alias ElixirScribe.Template.BindingAPI
  alias ElixirScribe.Template.FileAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "it injects an EEX template before the module end tag", config do
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

      expected_api_content = """
      defmodule API do
        def create(), do: :create
      end
      """

      base_template_paths = ElixirScribe.base_template_paths()

      binding =
        domain_contract_fixture()
        |> BindingAPI.build_binding_template()
        |> BindingAPI.rebuild_binding_template("create",
          file_type: :lib_core
        )

      assert :ok =
               FileAPI.inject_eex_template_before_module_end(
                 base_template_paths,
                 "api_function_template.ex",
                 "api_existing_module.ex",
                 binding
               )

      assert_received {:mix_shell, :info, ["* injecting api_existing_module.ex"]}

      assert_file("api_existing_module.ex", fn file ->
        assert file === expected_api_content
      end)
    end)
  end

  test "doesn't inject an EEX template when already exists in the module", config do
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

      refute_received {:mix_shell, :info, ["* injecting api_existing_module.ex"]}

      assert_file("api_existing_module.ex", fn file ->
        assert file === expected_api_content
      end)
    end)
  end
end
