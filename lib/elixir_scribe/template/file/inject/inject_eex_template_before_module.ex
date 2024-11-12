defmodule ElixirScribe.Template.File.Inject.InjectEExTemplateBeforeModuleEnd do
  @moduledoc false
  alias ElixirScribe.Template.FileAPI

  def inject(base_template_paths, source_path, target_path, binding)
      when is_list(base_template_paths) and is_binary(source_path) and is_binary(target_path) and
             is_list(binding) do
    base_template_paths
    |> Mix.Phoenix.eval_from(source_path, binding)
    |> FileAPI.inject_content_before_module_end(target_path)
  end
end
