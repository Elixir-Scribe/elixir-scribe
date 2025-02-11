defmodule ElixirScribe.Template.Module.BuildName.BuildModuleActionName do
  @moduledoc false

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Utils.StringAPI

  def build(%DomainContract{} = context, action) when is_binary(action) do
    schema =
      (action in ElixirScribe.resource_plural_actions() && context.schema.alias_plural) ||
        context.schema.alias

    action_capitalized = action |> StringAPI.capitalize()

    "#{action_capitalized}#{inspect(schema)}"
  end
end
