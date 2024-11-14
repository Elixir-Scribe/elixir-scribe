defmodule ElixirScribe.Template.FileAPI do
  @moduledoc false

  alias ElixirScribe.Template.BuildFilenameForActionFileContract
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.File.Inject.InjectContentBeforeModuleEnd
  alias ElixirScribe.Template.File.Inject.InjectEExTemplateBeforeModuleEnd
  alias ElixirScribe.Template.File.BuildFilenameForAction.BuildFilenameForActionFile
  alias ElixirScribe.Template.File.BuildPathForHtml.BuildPathForHtmlFile

  def build_dir_path_for_html_file(%DomainContract{} = contract),
    do: BuildPathForHtmlFile.build(contract)

  def build_template_action_filename(%BuildFilenameForActionFileContract{} = contract),
    do: BuildFilenameForActionFile.build(contract)

  def inject_content_before_module_end(content_to_inject, file_path)
      when is_binary(content_to_inject) and is_binary(file_path),
      do: InjectContentBeforeModuleEnd.inject(content_to_inject, file_path)

  def inject_eex_template_before_module_end(
        base_template_paths,
        source_path,
        target_path,
        binding
      )
      when is_list(base_template_paths) and is_binary(source_path) and is_binary(target_path) and
             is_list(binding),
      do:
        InjectEExTemplateBeforeModuleEnd.inject(
          base_template_paths,
          source_path,
          target_path,
          binding
        )
end
