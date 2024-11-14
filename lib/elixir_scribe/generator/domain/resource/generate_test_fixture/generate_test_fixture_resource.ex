defmodule ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResource do
  @moduledoc false

  alias ElixirScribe.Template.BindingAPI
  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Template.FileAPI

  def generate(%DomainContract{} = contract),
    do: generate_test_fixture_file(contract)

  @doc false
  def generate_test_fixture_file(contract) do
    base_template_paths = ElixirScribe.base_template_paths()
    binding = BindingAPI.build_binding_template(contract)

    contract
    |> ensure_test_fixtures_file_exists(base_template_paths, binding)
    |> inject_test_fixture(base_template_paths, binding)

    contract
  end

  @doc false
  def ensure_test_fixtures_file_exists(
        %DomainContract{test_fixtures_file: test_fixtures_file} = contract,
        base_template_paths,
        binding
      ) do
    unless File.exists?(test_fixtures_file) do
      fixtures_module_template_path =
        ElixirScribe.domain_tests_template_path() |> Path.join("fixtures_module.ex")

      Mix.Generator.create_file(
        test_fixtures_file,
        Mix.Phoenix.eval_from(base_template_paths, fixtures_module_template_path, binding)
      )
    end

    contract
  end

  defp inject_test_fixture(
         %DomainContract{test_fixtures_file: test_fixtures_file, opts: opts} = contract,
         base_template_paths,
         binding
       ) do
    no_default_actions = Keyword.get(opts, :no_default_actions, false)

    unless no_default_actions do
      fixtures_file_template_path =
        ElixirScribe.domain_tests_template_path() |> Path.join("fixtures.ex")

      FileAPI.inject_eex_template_before_module_end(
        base_template_paths,
        fixtures_file_template_path,
        test_fixtures_file,
        binding
      )

      maybe_print_unimplemented_fixture_functions(contract)
    end
  end

  defp maybe_print_unimplemented_fixture_functions(%DomainContract{} = contract) do
    fixture_functions_needing_implementations =
      Enum.flat_map(
        contract.schema.fixture_unique_functions,
        fn
          {_field, {_function_name, function_def, true}} -> [function_def]
          {_field, {_function_name, _function_def, false}} -> []
        end
      )

    if Enum.any?(fixture_functions_needing_implementations) do
      Mix.shell().info("""

      Some of the generated database columns are unique. Please provide
      unique implementations for the following fixture function(s) in
      #{contract.test_fixtures_file}:

      #{fixture_functions_needing_implementations |> Enum.map_join(&indent(&1, 2)) |> String.trim_trailing()}
      """)
    end

    contract
  end

  defp indent(string, spaces) do
    indent_string = String.duplicate(" ", spaces)

    string
    |> String.split("\n")
    |> Enum.map_join(fn line ->
      if String.trim(line) == "" do
        "\n"
      else
        indent_string <> line <> "\n"
      end
    end)
  end
end
