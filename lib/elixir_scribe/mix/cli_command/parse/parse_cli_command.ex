defmodule ElixirScribe.Mix.CLICommand.Parse.ParseCLICommand do
  @moduledoc false

  @supported_options [
    # binary_id: :boolean,
    table: :string,
    web: :string,
    schema: :boolean,
    context_app: :string,
    merge_with_existing_context: :boolean,
    prefix: :string,
    live: :boolean,
    actions: :string,
    no_default_actions: :boolean,
    html_template: :string
  ]

  @default_opts [
    schema: true,
    no_default_actions: false,
    actions: nil,
    html_template: "default"
  ]

  def parse(args) when is_list(args) do
    {opts, parsed_args, invalid_opts} =
      args
      # |> maybe_add_binary_id_option()
      |> extract_args_and_opts()

    all_opts = opts |> parse_options()

    {parsed_args, all_opts, invalid_opts}
  end

  # defp maybe_add_binary_id_option(args) when is_list(args) do
  #   cond do
  #     "--no-binary-id" in args -> args
  #     "--binary-id" in args -> args
  #     args -> args |> List.insert_at(-1, "--binary-id")
  #   end
  # end

  defp extract_args_and_opts(args) do
    OptionParser.parse(args, strict: @supported_options)
  end

  defp parse_options(opts) when is_list(opts) do
    @default_opts
    |> Keyword.merge(opts)
    |> put_context_app(opts[:context_app])
    |> put_resource_actions()
  end

  defp put_context_app(opts, nil), do: opts

  defp put_context_app(opts, string) do
    Keyword.put(opts, :context_app, String.to_atom(string))
  end

  defp put_resource_actions(opts) do
    resource_actions = build_actions_from_options(opts)
    Keyword.put(opts, :resource_actions, resource_actions)
  end

  defp build_actions_from_options(opts) when is_list(opts) do
    no_default_actions = (opts[:no_default_actions] && true) || false

    if no_default_actions do
      actions(opts[:actions])
    else
      (ElixirScribe.resource_actions() ++ actions(opts[:actions]))
      |> Enum.uniq()
    end
  end

  defp actions(actions) when is_binary(actions) and byte_size(actions) > 0,
    do: actions |> String.split(",")

  # defp actions(actions) when is_list(actions) and length(actions) > 0, do: actions
  defp actions(_actions), do: []
end
