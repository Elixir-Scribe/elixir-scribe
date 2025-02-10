Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Template.File.Inject.InjectContentBeforeModuleEndTest do
  alias ElixirScribe.Template.FileAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "it injects content in the module before the final end tag", config do
    in_tmp(config.test, fn ->
      api_content = """
      defmodule API do
        def whatever(), do: :whatever
      end
      """

      File.write!("api.ex", api_content)

      content_to_inject = """

        def something(), do: :something
      """

      expected_api_content = """
      defmodule API do
        def whatever(), do: :whatever

        def something(), do: :something
      end
      """

      assert :ok = FileAPI.inject_content_before_module_end(content_to_inject, "api.ex")

      assert_received {:mix_shell, :info, ["* injecting api.ex"]}

      assert_file("api.ex", fn file ->
        assert file === expected_api_content
      end)
    end)
  end

  test "doesn't inject the content when already present in the module", config do
    in_tmp(config.test, fn ->
      content_to_inject = """

        def something(), do: :something
      """

      expected_api_content = """
      defmodule API do
        def whatever(), do: :whatever

        def something(), do: :something
      end
      """

      File.write!("api.ex", expected_api_content)

      assert {:noop, :content_to_inject_already_exists} =
               FileAPI.inject_content_before_module_end(content_to_inject, "api.ex")

      refute_received {:mix_shell, :info, ["* injecting api.ex"]}

      assert_file("api.ex", fn file ->
        assert file === expected_api_content
      end)
    end)
  end
end
