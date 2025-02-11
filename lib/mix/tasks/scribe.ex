defmodule Mix.Tasks.Scribe do
  use Mix.Task

  @shortdoc "Prints Elixir Scribe help information"

  @moduledoc """
  Prints Elixir Scribe tasks and their information.

      $ mix scribe

  To print the Phoenix version, pass `-v` or `--version`, for example:

      $ mix scribe --version

  """

  @version Mix.Project.config()[:version]

  @impl true
  @doc false
  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Elixir Scribe v#{@version}")
  end

  def run(args) do
    case args do
      [] -> help()
      _ -> Mix.raise("Invalid arguments, expected: mix scribe")
    end
  end

  defp help() do
    Application.ensure_all_started(:phoenix)
    Mix.shell().info("Elixir Scribe v#{Application.spec(:phoenix, :vsn)}")

    Mix.shell().info(
      "\nEnables craftsmanship through Clean Code in a Clean Software Architecture\n"
    )

    Mix.shell().info("\n## Options\n")
    Mix.shell().info("-v, --version         # Prints Elixir Scribe version\n")
    Mix.shell().info("\n## Tasks\n")
    Mix.Tasks.Help.run(["--search", "scribe."])
  end
end
