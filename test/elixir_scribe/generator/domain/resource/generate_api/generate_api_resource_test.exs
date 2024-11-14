Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Generator.Domain.Resource.GenerateApi.GenerateApiResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.DomainResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the Resource API file with the default actions", config do
    in_tmp_project(config.test, fn ->
      domain_contract_fixture()
      |> DomainResourceAPI.generate_api()

      assert_file("lib/elixir_scribe/domain/sales/catalog/product_api.ex", fn file ->
        assert_default_actions(file, resource: "Product", domain: "Catalog")
      end)
    end)
  end

  test "generates the Resource API file with extra actions (export,import)", config do
    in_tmp_project(config.test, fn ->
      %{optional: [
        "--actions",
        "export,import"
      ]}
      |> domain_contract_fixture()
      |> DomainResourceAPI.generate_api()

      assert_file("lib/elixir_scribe/domain/sales/catalog/product_api.ex", fn file ->
        assert_default_actions(file, resource: "Product", domain: "Catalog")
        assert file =~ "def import(), do: ImportProductCatalogHandler.import()"
        assert file =~ "def export(), do: ExportProductCatalogHandler.export()"
      end)
    end)
  end

  test "generates the Resource API file without the default actions when creating only extra actions (export,import)",
       config do
    in_tmp_project(config.test, fn ->
      %{optional: [
        "--no-default-actions",
        "--actions",
        "export,import"
      ]}
      |> domain_contract_fixture()
      |> DomainResourceAPI.generate_api()

      assert_file("lib/elixir_scribe/domain/sales/catalog/product_api.ex", fn file ->
        refute_default_actions(file, resource: "Product", domain: "Catalog")
        assert file =~ "def import(), do: ImportProductCatalogHandler.import()"
        assert file =~ "def export(), do: ExportProductCatalogHandler.export()"
      end)
    end)
  end

  test "generates the Resource API file correctly for a two words resource (product_statistics)",
       config do
    in_tmp_project(config.test, fn ->
      args = [
        "Sales.Catalog",
        "ProductStatistic",
        "product_statistics",
        "slug:unique",
        "categories:integer"
      ]

      contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/sales/catalog/product_statistic_api.ex", fn file ->
        # We need to assert and refute because the struct is used several times
        assert file =~ "%ProductStatistic"
        refute file =~ "%Product statistic"

        assert_default_actions(file, resource: "ProductStatistic", domain: "Catalog")
      end)
    end)
  end

  defp assert_default_actions(file, resource: resource, domain: domain) do
    assert file =~ "iex> #{resource}API.list()"
    assert file =~ "def list(), do: List#{resource}s#{domain}Handler.list()"

    assert file =~ "iex> #{resource}API.new()"
    assert file =~ "def new(attrs \\\\ %{}) when is_map(attrs), do: New#{resource}#{domain}Handler.new(attrs)"

    assert file =~ "iex> #{resource}API.read!(\""
    assert file =~ "def read!(uuid) when is_binary(uuid), do: Read#{resource}#{domain}Handler.read!(uuid)"

    assert file =~ "iex> #{resource}API.edit(\""

    assert file =~
             "def edit(uuid, attrs \\\\ %{}) when is_binary(uuid) and is_map(attrs), do: Edit#{resource}#{domain}Handler.edit(uuid, attrs)"

    assert file =~ "iex> #{resource}API.create(%{"
    assert file =~ "def create(attrs) when is_map(attrs), do: Create#{resource}#{domain}Handler.create(attrs)"

    assert file =~ "iex> #{resource}API.update(\""

    assert file =~
             "def update(uuid, attrs) when is_binary(uuid) and is_map(attrs), do: Update#{resource}#{domain}Handler.update(uuid, attrs)"

    assert file =~ "iex> #{resource}API.delete(\""
    assert file =~ "def delete(uuid) when is_binary(uuid), do: Delete#{resource}#{domain}Handler.delete(uuid)"
  end

  defp refute_default_actions(file, resource: resource, domain: domain) do
    refute file =~ "iex> #{resource}API.list()"
    refute file =~ "def list(), do: List#{resource}s#{domain}Handler.list()"

    refute file =~ "iex> #{resource}API.new()"
    refute file =~ "def new(attrs \\\\ %{}) when is_map(attrs), do: New#{resource}#{domain}Handler.new(attrs)"

    refute file =~ "iex> #{resource}API.read!(\""
    refute file =~ "def read!(uuid) when is_binary(uuid), do: Read#{resource}#{domain}Handler.read!(uuid)"

    refute file =~ "iex> #{resource}API.edit(\""

    refute file =~
             "def edit(uuid, attrs \\\\ %{}) when is_binary(uuid) and is_map(attrs), do: Edit#{resource}#{domain}Handler.edit(uuid, attrs)"

    refute file =~ "iex> #{resource}API.create(%{"
    refute file =~ "def create(attrs) when is_map(attrs), do: Create#{resource}#{domain}Handler.create(attrs)"

    refute file =~ "iex> #{resource}API.update(\""

    refute file =~
             "def update(uuid, attrs) when is_binary(uuid) and is_map(attrs), do: Update#{resource}#{domain}Handler.update(uuid, attrs)"

    refute file =~ "iex> #{resource}API.delete(\""
    refute file =~ "def delete(uuid) when is_binary(uuid), do: Delete#{resource}#{domain}Handler.delete(uuid)"
  end
end
