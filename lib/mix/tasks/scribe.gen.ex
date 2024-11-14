defmodule Mix.Tasks.Scribe.Gen do
  # This module was borrowed from the Phoenix Framework module
  # Mix.Tasks.Phx.Gen and modified to suite ElixirScribe needs.

  use Mix.Task

  @shortdoc "Lists all available Scribe generators"

  @moduledoc """
  Lists all available Scribe generators:

  ```console
  mix scribe.gen
  ```
  """

  @doc false
  def run(_args) do
    Mix.Task.run("help", ["--search", "scribe.gen."])
  end
end
