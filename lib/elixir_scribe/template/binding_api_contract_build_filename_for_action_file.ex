defmodule ElixirScribe.Template.BuildFilenameForActionFileContract do
  @moduledoc false

  @fields %{
    required: [:action, :action_suffix, :file_type, :file_extension],
    optional: []
  }

  use ElixirScribe.Behaviour.TypedContract, fields: @fields

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      action: is_binary() |> spec(),
      action_suffix: is_binary() |> spec(),
      file_type: is_binary() |> spec(),
      file_extension: is_binary() |> spec()
    })
  end
end
