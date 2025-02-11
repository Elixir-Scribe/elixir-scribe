defmodule ElixirScribeTest do
  use ElixirScribe.BaseCase, async: true

  doctest ElixirScribe

  describe "base_template_paths/0" do
    test "returns a list of base paths in the expected order" do
      assert ElixirScribe.base_template_paths() === [".", :elixir_scribe, :phoenix]
    end
  end

  describe "app_name/0" do
    test "return the app name as a string" do
      assert ElixirScribe.app_name() === "elixir_scribe"
    end
  end

  describe "app_path/1" do
    test "returns app path for :lib_core" do
      assert ElixirScribe.app_path(:lib_core) === "lib/elixir_scribe"
    end

    test "returns app path for :test_core" do
      assert ElixirScribe.app_path(:test_core) === "test/elixir_scribe"
    end

    test "returns app path for :lib_web" do
      assert ElixirScribe.app_path(:lib_web) === "lib/elixir_scribe_web"
    end

    test "returns app path for :test_web" do
      assert ElixirScribe.app_path(:test_web) === "test/elixir_scribe_web"
    end
  end

  describe "web_template_path/0" do
    test "returns the web template path" do
      assert ElixirScribe.web_template_path() === "priv/templates/scribe.gen.html"
    end
  end

  describe "html_template_path/0" do
    test "returns the html template path" do
      assert ElixirScribe.html_template_path() === "priv/templates/scribe.gen.html/html"
    end
  end

  describe "controller_template_path/0" do
    test "returns the controller template path" do
      assert ElixirScribe.controller_template_path() ===
               "priv/templates/scribe.gen.html/controllers"
    end
  end

  describe "controller_test_template_path/0" do
    test "returns the controller test template path" do
      assert ElixirScribe.controller_test_template_path() ===
               "priv/templates/scribe.gen.html/tests/controllers"
    end
  end

  describe "domain_template_path/0" do
    test "returns the domain template path" do
      assert ElixirScribe.domain_template_path() === "priv/templates/scribe.gen.domain"
    end
  end

  describe "domain_tests_template_path/0" do
    test "returns the default domain tests template path" do
      assert ElixirScribe.domain_tests_template_path() ===
               "priv/templates/scribe.gen.domain/tests"
    end
  end

  describe "domain_api_template_path/0" do
    test "returns the default domain api template path" do
      assert ElixirScribe.domain_api_template_path() === "priv/templates/scribe.gen.domain/apis"
    end
  end

  describe "resource_actions_template_path/0" do
    test "returns the default domain actions template path" do
      assert ElixirScribe.resource_actions_template_path() ===
               "priv/templates/scribe.gen.domain/actions"
    end
  end

  describe "resource_actions/0" do
    test "returns the resource actions in the expected order" do
      assert ElixirScribe.resource_actions() === [
               "list",
               "new",
               "read",
               "edit",
               "create",
               "update",
               "delete"
             ]
    end
  end

  describe "resource_actions_aliases/0" do
    test "returns an empty map when no aliases are configured in the app config" do
      assert ElixirScribe.resource_actions_aliases() === %{}
    end
  end

  describe "resource_action_alias/1" do
    test "returns the same action when no alias is configured for action in the app config" do
      assert ElixirScribe.resource_action_alias("create") === "create"
    end
  end

  describe "resource_html_actions/0" do
    test "returns the resource html actions in the expected order" do
      assert ElixirScribe.resource_html_actions() === ["read", "new", "edit", "list"]
    end
  end

  describe "resource_plural_actions/0" do
    test "returns the resource plural actions" do
      assert ElixirScribe.resource_plural_actions() === ["index", "list"]
    end
  end

  describe "schema_template_folder_name/1" do
    test "returns `schema_access` as the folder template name when schema.generate? is true" do
      domain_contract = domain_contract_fixture()

      assert ElixirScribe.schema_template_folder_name(domain_contract.schema) === "schema_access"
    end

    test "returns `no_schema_access` as the folder template name when schema.generate? is false" do
      domain_contract = domain_contract_fixture()
      schema = Map.put(domain_contract.schema, :generate?, false)

      assert ElixirScribe.schema_template_folder_name(schema) === "no_schema_access"
    end
  end

  describe "app_file_extensions/0" do
    test "it returns a list with all app file extensions" do
      assert ElixirScribe.app_file_extensions() === [".ex", ".exs", "html.heex"]
    end
  end

  describe "app_file_types/0" do
    test "it returns a list with all app file types" do
      assert ElixirScribe.app_file_types() === ["", "controller", "controller_test", "test"]
    end
  end

  describe "app_path_types/0" do
    test "it returns a list with all file path types" do
      assert ElixirScribe.app_path_types() === [:lib_core, :lib_web, :test_core, :test_web]
    end
  end
end
