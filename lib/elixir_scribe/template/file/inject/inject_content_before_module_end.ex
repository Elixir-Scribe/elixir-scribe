defmodule ElixirScribe.Template.File.Inject.InjectContentBeforeModuleEnd do
  @moduledoc false

  def inject(content_to_inject, file_path)
      when is_binary(content_to_inject) and is_binary(file_path) do
    file_content = File.read!(file_path)

    if String.contains?(file_content, content_to_inject) do
      {:noop, :content_to_inject_already_exists}
    else
      Mix.shell().info([:green, "* injecting ", :reset, Path.relative_to_cwd(file_path)])

      file_content
      |> String.trim_trailing()
      |> String.trim_trailing("end")
      |> Kernel.<>(content_to_inject)
      |> Kernel.<>("end\n")
      |> write_file(file_path)
    end
  end

  defp write_file(content, file_path) do
    File.write!(file_path, content)
  end
end
