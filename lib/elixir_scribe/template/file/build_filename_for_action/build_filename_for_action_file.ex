defmodule ElixirScribe.Template.File.BuildFilenameForAction.BuildFilenameForActionFile do
  @moduledoc false
  alias ElixirScribe.Template.BuildFilenameForActionFileContract

  def build(%BuildFilenameForActionFileContract{} = contract) do
    case contract.action in ElixirScribe.resource_actions() do
      true ->
        "#{contract.action}#{contract.action_suffix}#{contract.file_type}#{contract.file_extension}"

      false ->
        "default#{contract.action_suffix}#{contract.file_type}#{contract.file_extension}"
    end
  end
end
