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
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "secret:redact",
        "title:string"
      ]

      contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/blog/post_api.ex", fn file ->
        assert_default_actions(file, resource: "Post")
      end)
    end)
  end

  test "generates the Resource API file with extra actions (export,import)", config do
    in_tmp_project(config.test, fn ->
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "secret:redact",
        "title:string",
        "--actions",
        "export,import"
      ]

      contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/blog/post_api.ex", fn file ->
        assert_default_actions(file, resource: "Post")
        assert file =~ "def import(), do: ImportPost.import()"
        assert file =~ "def export(), do: ExportPost.export()"
      end)
    end)
  end

  test "generates the Resource API file without the default actions when creating only extra actions (export,import)",
       config do
    in_tmp_project(config.test, fn ->
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "secret:redact",
        "title:string",
        "--no-default-actions",
        "--actions",
        "export,import"
      ]

      contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/blog/post_api.ex", fn file ->
        refute_default_actions(file, resource: "Post")
        assert file =~ "def import(), do: ImportPost.import()"
        assert file =~ "def export(), do: ExportPost.export()"
      end)
    end)
  end

  test "generates the Resource API file correctly for a two words resource (guest_posts)",
       config do
    in_tmp_project(config.test, fn ->
      args = [
        "Blog",
        "GuestPost",
        "guest_posts",
        "slug:unique",
        "secret:redact",
        "title:string"
      ]

      contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_api(contract)

      assert_file("lib/elixir_scribe/domain/blog/guest_post_api.ex", fn file ->
        # We need to assert and refute because the struct is used several times
        assert file =~ "%GuestPost"
        refute file =~ "%Guest post"

        assert_default_actions(file, resource: "GuestPost")
      end)
    end)
  end

  defp assert_default_actions(file, resource: resource) do
    assert file =~ "iex> #{resource}API.list()"
    assert file =~ "def list(), do: List#{resource}s.list()"

    assert file =~ "iex> #{resource}API.new()"
    assert file =~ "def new(attrs \\\\ %{}) when is_map(attrs), do: New#{resource}.new(attrs)"

    assert file =~ "iex> #{resource}API.read!(\""
    assert file =~ "def read!(uuid) when is_binary(uuid), do: Read#{resource}.read!(uuid)"

    assert file =~ "iex> #{resource}API.edit(\""

    assert file =~
             "def edit(uuid, attrs \\\\ %{}) when is_binary(uuid) and is_map(attrs), do: Edit#{resource}.edit(uuid, attrs)"

    assert file =~ "iex> #{resource}API.create(%{"
    assert file =~ "def create(attrs) when is_map(attrs), do: Create#{resource}.create(attrs)"

    assert file =~ "iex> #{resource}API.update(\""

    assert file =~
             "def update(uuid, attrs) when is_binary(uuid) and is_map(attrs), do: Update#{resource}.update(uuid, attrs)"

    assert file =~ "iex> #{resource}API.delete(\""
    assert file =~ "def delete(uuid) when is_binary(uuid), do: Delete#{resource}.delete(uuid)"
  end

  defp refute_default_actions(file, resource: resource) do
    refute file =~ "iex> #{resource}API.list()"
    refute file =~ "def list(), do: List#{resource}s.list()"

    refute file =~ "iex> #{resource}API.new()"
    refute file =~ "def new(attrs \\\\ %{}) when is_map(attrs), do: New#{resource}.new(attrs)"

    refute file =~ "iex> #{resource}API.read!(\""
    refute file =~ "def read!(uuid) when is_binary(uuid), do: Read#{resource}.read!(uuid)"

    refute file =~ "iex> #{resource}API.edit(\""

    refute file =~
             "def edit(uuid, attrs \\\\ %{}) when is_binary(uuid) and is_map(attrs), do: Edit#{resource}.edit(uuid, attrs)"

    refute file =~ "iex> #{resource}API.create(%{"
    refute file =~ "def create(attrs) when is_map(attrs), do: Create#{resource}.create(attrs)"

    refute file =~ "iex> #{resource}API.update(\""

    refute file =~
             "def update(uuid, attrs) when is_binary(uuid) and is_map(attrs), do: Update#{resource}.update(uuid, attrs)"

    refute file =~ "iex> #{resource}API.delete(\""
    refute file =~ "def delete(uuid) when is_binary(uuid), do: Delete#{resource}.delete(uuid)"
  end
end
