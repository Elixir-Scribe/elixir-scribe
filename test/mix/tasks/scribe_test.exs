# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.ScribeTest do
  use ElixirScribe.BaseCase

  test "It list all Elixir Scribe tasks" do
    Mix.Tasks.Scribe.run([])
    assert_received {:mix_shell, :info, ["mix scribe.gen" <> _]}
    assert_received {:mix_shell, :info, ["mix scribe.gen.html" <> _]}
    assert_received {:mix_shell, :info, ["mix scribe.gen.domain" <> _]}
  end

  test "expects no arguments" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Scribe.run(["invalid"])
    end
  end
end
