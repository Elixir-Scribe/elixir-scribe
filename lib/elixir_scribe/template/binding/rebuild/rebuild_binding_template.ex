defmodule ElixirScribe.Template.Binding.Rebuild.RebuildBindingTemplate do
  @moduledoc false

  alias ElixirScribe.Template.ModuleAPI
  alias ElixirScribe.Utils.StringAPI

  def rebuild(bindings, action, opts)
      when is_list(bindings) and is_binary(action) and is_list(opts) do
    contract = Keyword.get(bindings, :contract)

    Keyword.merge(bindings,
      action: action,
      action_first_word: StringAPI.first_word(action),
      action_capitalized: StringAPI.capitalize(action),
      action_human_capitalized: StringAPI.human_capitalize(action),
      module_action_name: ModuleAPI.build_module_action_name(contract, action),
      absolute_module_action_name:
        ModuleAPI.build_absolute_module_action_name(contract, action, opts)
    )
  end
end
