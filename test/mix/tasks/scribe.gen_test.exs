# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.Scribe.GenTest do
  use ElixirScribe.BaseCase

  test "It list all Elixir Scribe generators" do
    Mix.Tasks.Scribe.Gen.run([])
    assert_received {:mix_shell, :info, ["mix scribe.gen.html" <> _]}
    assert_received {:mix_shell, :info, ["mix scribe.gen.domain" <> _]}
  end
end
