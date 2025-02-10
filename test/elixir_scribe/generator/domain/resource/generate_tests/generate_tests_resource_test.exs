Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Generator.Domain.Resource.GenerateTests.GenerateTestsResourceTest do
  alias ElixirScribe.Generator.DomainResourceAPI
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "with flag --no-schema the test file is generated without tests being implemented ",
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
      DomainResourceAPI.generate_tests(domain_contract)

      assert_file("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPostsTest do"
        assert file =~ "test \"list"
        assert file =~ "raise \"TODO: Implement test for action `list` at `ListPosts`"
      end)
    end)
  end

  test "generates a test file for each Resource Action", config do
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

      DomainResourceAPI.generate_tests(contract)

      assert_file("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.List.ListPostsTest do"
        assert file =~ "test \"list/0"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/new/new_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.New.NewPostTest do"
        assert file =~ "test \"new/0"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/read/read_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Read.ReadPostTest do"
        assert file =~ "test \"read!/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/edit/edit_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Edit.EditPostTest do"
        assert file =~ "test \"edit/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/create/create_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Create.CreatePostTest do"
        assert file =~ "test \"create/1"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/update/update_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Update.UpdatePostTest do"
        assert file =~ "test \"update/2"
      end)

      assert_file("test/elixir_scribe/domain/blog/post/delete/delete_post_test.exs", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.Post.Delete.DeletePostTest do"
        assert file =~ "test \"delete/1"
      end)
    end)
  end
end
