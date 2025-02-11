defmodule ElixirScribe.Mix.CLICommand.ParseSchema.ParseSchemaCLICommand do
  @moduledoc false

  @supported_options [
    migration: :boolean,
    table: :string,
    web: :string,
    prefix: :string,
    repo: :string,
    migration_dir: :string
  ]

  @default_opts [
    migration: true
  ]

  def parse(args) when is_list(args) do
    {opts, parsed_args, invalid_opts} =
      args
      |> extract_args_and_opts()

    all_opts = opts |> parse_options()

    {parsed_args, all_opts, invalid_opts}
  end

  defp extract_args_and_opts(args) do
    OptionParser.parse(args, strict: @supported_options)
  end

  defp parse_options(opts) when is_list(opts) do
    @default_opts
    |> Keyword.merge(opts)
  end
end
