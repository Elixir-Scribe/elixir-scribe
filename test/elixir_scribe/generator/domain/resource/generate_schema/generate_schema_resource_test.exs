Code.require_file("test//mix_test_helper.exs")

defmodule ElixirScribe.Generator.Domain.Resource.GenerateSchema.GenerateSchemaResourceTest do
  alias ElixirScribe.Generator.DomainResourceAPI

  use ElixirScribe.BaseCase
  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the Resource Schema file", config do
    in_tmp_project(config.test, fn ->
      contract = domain_contract_fixture()
      DomainResourceAPI.generate_schema(contract)

      assert_file("lib/elixir_scribe/domain/site/blog/post/post_schema.ex", fn file ->
        assert file =~ "field :name, :string"
        assert file =~ "field :desc, :string"
      end)
    end)
  end

  test "doesn't generate the Resource Schema file when the flag --no-schema is used", config do
    in_tmp_project(config.test, fn ->
      args = ["Blog", "Post", "posts", "title:string", "desc:string", "--no-schema"]

      contract = domain_contract_fixture(args)

      DomainResourceAPI.generate_schema(contract)

      refute File.exists?("lib/elixir_scribe/domain/site/blog/post/post_schema.ex")
    end)
  end
end
