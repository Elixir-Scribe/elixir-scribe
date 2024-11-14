defmodule ElixirScribe.Mix.CLICommand.ParseSchema.ParseSchemaCLICommand do
  @moduledoc false

  @supported_options [
    migration: :boolean,
    table: :string,
    web: :string,
    context_app: :string,
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

    # |> put_context_app(opts[:context_app])
  end

  # defp put_context_app(opts, nil), do: opts

  # defp put_context_app(opts, string) do
  #   Keyword.put(opts, :context_app, String.to_atom(string))
  # end
end
