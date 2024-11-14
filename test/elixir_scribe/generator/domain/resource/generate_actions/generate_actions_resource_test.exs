Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Generator.Domain.Resource.GenerateActions.GenerateActionsResourceTest do
  alias ElixirScribe.Generator.DomainResourceAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "with flag --no-schema the resource action file is generated without the logic to access the schema",
       config do
    in_tmp_project(config.test, fn ->
      args = %{
        optional: [
          "--no-schema"
        ]
      }

      domain_contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_actions(domain_contract)

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/list/list_products_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.List.ListProductsCatalogHandler do"

          assert file =~ "def list()"
          assert file =~ "raise \"TODO: Implement the action `list` for the module `ListProductsCatalogHandler`"
        end
      )
    end)
  end

  test "generates a file for each Resource Action", config do
    in_tmp_project(config.test, fn ->
      args = %{
        optional: [
          "--actions",
          "export,import"
        ]
      }

      contract = domain_contract_fixture(args)

      DomainResourceAPI.generate_actions(contract)

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/list/list_products_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.List.ListProductsCatalogHandler do"

          assert file =~ "def list()"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/new/new_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.New.NewProductCatalogHandler do"

          assert file =~ "def new(attrs \\\\ %{})"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/read/read_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.Read.ReadProductCatalogHandler do"

          assert file =~ "def read!(uuid)"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/edit/edit_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.Edit.EditProductCatalogHandler do"

          assert file =~ "def edit(uuid, attrs \\\\ %{})"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/create/create_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.Create.CreateProductCatalogHandler do"

          assert file =~ "def create(%{} = attrs)"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/update/update_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.Update.UpdateProductCatalogHandler do"

          assert file =~ "def update(uuid, %{} = attrs)"
        end
      )

      assert_file(
        "lib/elixir_scribe/domain/sales/catalog/product/delete/delete_product_catalog_handler.ex",
        fn file ->
          assert file =~
                   "defmodule ElixirScribe.Sales.Catalog.Product.Delete.DeleteProductCatalogHandler do"

          assert file =~ "def delete(uuid)"
        end
      )
    end)
  end
end
