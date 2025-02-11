defmodule ElixirScribe.MixAPI do
  @moduledoc false

  alias ElixirScribe.Mix.Shell.PromptForFileConflicts.PromptForFileConflictsShell
  alias ElixirScribe.Mix.CLICommand.Parse.ParseCLICommand
  alias ElixirScribe.Mix.CLICommand.ParseSchema.ParseSchemaCLICommand

  @doc """
  Parses the provided list, that represents the CLI command, into one list of arguments and one list of options. The returned options will include all the options with their defaults.

  It returns a tuple in this format: `{parsed_args, all_opts, invalid}`.
  """
  def parse_cli_command(args) when is_list(args), do: ParseCLICommand.parse(args)

  @doc """
  Parses the provided list, that represents the Schema CLI command, into one list of arguments and one list of options. The returned options will include all the options with their defaults.

  It returns a tuple in this format: `{parsed_args, all_opts, invalid}`.
  """
  def parse_schema_cli_command(args) when is_list(args), do: ParseSchemaCLICommand.parse(args)

  @doc """
  Prompts to continue if any files exist.
  """
  def prompt_for_file_conflicts(files) when is_list(files),
    do: PromptForFileConflictsShell.prompt(files)
end
