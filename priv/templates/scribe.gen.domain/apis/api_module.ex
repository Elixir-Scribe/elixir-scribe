defmodule <%= inspect absolute_module_name %>API do
  @moduledoc """
  The <%= inspect contract.name %> <%= contract.schema.human_singular %> API.
  """
  <%= aliases %>
end
