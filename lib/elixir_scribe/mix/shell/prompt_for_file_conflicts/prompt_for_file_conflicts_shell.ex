defmodule ElixirScribe.Mix.Shell.PromptForFileConflicts.PromptForFileConflictsShell do
  @moduledoc false

  # The function `prompt/1` was copied from the Phoenix Framework module at `/lib/mix/phoenix.ex`.
  # It was modified to use the `action` from the provided `generator_files`,
  # which is now a three elements tuple.

  @doc false
  def prompt(generator_files) when is_list(generator_files) do
    file_paths =
      Enum.flat_map(generator_files, fn
        {:new_eex, _, _path} -> []
        {_kind, _source_path, target_path} -> [target_path]
        {_kind, _file_type, _source_path, target_path} -> [target_path]
        {_kind, _file_type, _source_path, target_path, _action} -> [target_path]
      end)

    case Enum.filter(file_paths, &File.exists?(&1)) do
      [] ->
        :ok

      conflicts ->
        Mix.shell().info("""
        The following files conflict with new files to be generated:

        #{Enum.map_join(conflicts, "\n", &"  * #{&1}")}

        """)

        unless Mix.shell().yes?("Proceed with interactive overwrite?") do
          System.halt()
        end
    end
  end
end
