defmodule ElixirScribe.Template.Route.Scope.ScopeActionRoutes do
  @moduledoc false

  alias ElixirScribe.Template.ModuleAPI
  alias ElixirScribe.Generator.DomainContract

  def scope(%DomainContract{schema: schema} = contract) do
    resource = schema.plural
    controller = inspect(contract.web_resource_module)
    scope_alias = String.replace(schema.web_path, "/", "_") <> "_" <> resource

    """

      scope "/#{schema.web_path}/#{resource}", #{controller}, as: :#{scope_alias} do
        pipe_through :browser

        #{build_action_routes(contract)}
      end
    """
  end

  defp build_action_routes(%DomainContract{} = contract) do
    resource_actions = contract.opts |> Keyword.get(:resource_actions)

    for action <- resource_actions, reduce: "" do
      routes ->
        routes <> build_route_action(action, contract)
    end
    |> String.trim_leading()
  end

  defp build_route_action("create", contract) do
    assemble_route_action("post", "create", contract)
  end

  defp build_route_action("update", contract) do
    assemble_route_action("patch", "update", contract) <>
      assemble_route_action("put", "update", contract)
  end

  defp build_route_action("delete", contract) do
    assemble_route_action("delete", "delete", contract)
  end

  defp build_route_action(action, contract) do
    assemble_route_action("get", action, contract)
  end

  defp assemble_route_action(method, action, contract) do
    action_alias = ElixirScribe.resource_action_alias(action)
    endpoint = build_endpoint(action, action_alias)
    controller = build_controller(contract, action, action_alias)

    "\n    #{method} \"#{endpoint}\", #{controller}, :#{action_alias}"
  end

  @http_get_actions ["read", "new", "edit", "list"]
  @resource_id_actions ["read", "update", "delete"]

  defp build_endpoint("create", _action_alias), do: "/"
  defp build_endpoint("new", action_alias), do: "/#{action_alias}"
  defp build_endpoint("edit", action_alias), do: "/:id/#{action_alias}"

  defp build_endpoint(action, _action_alias) when action in @resource_id_actions,
    do: "/:id"

  defp build_endpoint(action, _action_alias) when action in @http_get_actions,
    do: "/"

  defp build_endpoint(_action, action_alias), do: "/#{action_alias}"

  defp build_controller(contract, action, action_alias) do
    action_capitalized = String.capitalize(action_alias)
    module_action_name = ModuleAPI.build_module_action_name(contract, action)

    "#{action_capitalized}.#{module_action_name}Controller"
  end
end
