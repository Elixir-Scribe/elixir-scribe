defmodule ElixirScribe.MixProject do
  use Mix.Project

  # The Elixir version here needs to be equal or greater then the one
  # used by the Phoenix Framework and Phoenix Installer.
  @elixir_requirement "~> 1.14"
  @scm_url "https://github.com/exadra37/elixir-scribe"

  @description """
  Elixir Scribe - A Mix Task to Generate Elixir and Phoenix Projects

  The Elixir Scribe tool aims to help developers to more easily write clean code in a clean software architecture for enhanced developer experience and productivity.
  """

  def project do
    [
      app: :elixir_scribe,
      name: "Elixir Scribe",
      version: "0.2.1",
      elixir: @elixir_requirement,
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      homepage_url: @scm_url,
      source_url: @scm_url,
      description: @description,
      package: package(),
      docs: docs(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Paulo Renato (Exadra37)"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      files: ~w(lib priv LICENSE.md mix.exs README.md .formatter.exs),
      exclude_patterns: [".local"]
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md"]
      # groups_for_extras: [
      #   Examples: ~r"test/examples"
      # ],
    ]
  end

  defp aliases do
    [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
    File.cp_r!("assets", "doc/assets")
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix, ">= 1.7.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:norm, "~> 0.13"},
      {:assertions, "0.19.0", only: [:test]}
    ]
  end
end
