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
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "title:string",
        "--no-schema"
      ]

      domain_contract = domain_contract_fixture(args)
      DomainResourceAPI.generate_actions(domain_contract)

      assert_file("lib/elixir_scribe/domain/blog/post/list/list_posts.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPosts do"
        assert file =~ "def list()"
        assert file =~ "raise \"TODO: Implement the action `list` for the module `ListPosts`"
      end)
    end)
  end

  test "generates a file for each Resource Action", config do
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

      DomainResourceAPI.generate_actions(contract)

      assert_file("lib/elixir_scribe/domain/blog/post/list/list_posts.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPosts do"
        assert file =~ "def list()"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/new/new_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPost do"
        assert file =~ "def new(attrs \\\\ %{})"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/read/read_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPost do"
        assert file =~ "def read!(uuid)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/edit/edit_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPost do"
        assert file =~ "def edit(uuid, attrs \\\\ %{})"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/create/create_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePost do"
        assert file =~ "def create(%{} = attrs)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/update/update_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePost do"
        assert file =~ "def update(uuid, %{} = attrs)"
      end)

      assert_file("lib/elixir_scribe/domain/blog/post/delete/delete_post.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePost do"
        assert file =~ "def delete(uuid)"
      end)
    end)
  end
end
