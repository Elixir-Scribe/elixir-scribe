Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Mix.Shell.PromptForFileConflicts.PromptForFileConflictsShellTest do
  alias ElixirScribe.MixAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "it prompts for file conflicts when the file already exists", config do
    in_tmp_project(config.test, fn ->
      files = [
        {:eex, "from/schema_template", "schema.ex"},
        {:eex, :api, "from/api_template_file", "api_file.ex"},
        {:eex, :resource, "from/resource_template_file", "create_resource.ex", "create"}
      ]

      File.touch("schema.ex")
      File.touch("api_file.ex")
      File.touch("create_resource.ex")

      expected_info = """
      The following files conflict with new files to be generated:

        * schema.ex
        * api_file.ex
        * create_resource.ex

      """

      send(self(), {:mix_shell_input, :yes?, true})
      MixAPI.prompt_for_file_conflicts(files)

      assert_received {:mix_shell, :info, [^expected_info]}

      assert_received {:mix_shell, :yes?, ["Proceed with interactive overwrite?" <> _]}
    end)
  end

  test "doesn't prompt for file conflicts when the file is :new_eex", config do
    in_tmp_project(config.test, fn ->
      files = [
        {:new_eex, "from/some_template", "new_eex_ignored.ex"}
      ]

      File.touch("new_eex_ignored.ex")

      expected_info = """
      The following files conflict with new files to be generated:

        * new_eex_ignored.ex

      """

      send(self(), {:mix_shell_input, :yes?, true})
      MixAPI.prompt_for_file_conflicts(files)

      refute_received {:mix_shell, :info, [^expected_info]}

      refute_received {:mix_shell, :yes?, ["Proceed with interactive overwrite?" <> _]}
    end)
  end

  test "doesn't prompt for file conflicts when the file doesn't exist", config do
    in_tmp_project(config.test, fn ->
      file = "new.ex"

      MixAPI.prompt_for_file_conflicts([{:ex, :any, file}])

      refute_received {:mix_shell, :info,
                       ["The following files conflict with new files to be generated:" <> _]}

      refute_received {:mix_shell_input, :yes?, true}
    end)
  end
end
