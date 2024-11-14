Code.require_file("test/mix_test_helper.exs")

defmodule ElixirScribe.Generator.Domain.Resource.GenerateTestFixture.GenerateTestFixtureResourceTest do
  use ElixirScribe.BaseCase

  alias ElixirScribe.Generator.DomainContract
  alias ElixirScribe.Generator.DomainResourceAPI

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates the file for the resource test fixture", config do
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

      assert %DomainContract{} = DomainResourceAPI.generate_test_fixture(contract)

      assert_file("test/support/fixtures/domain/blog/post_fixtures.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.PostFixtures do"
        assert file =~ "def post_fixture(attrs \\\\ %{})"
        assert file =~ "title: \"some title\""
      end)
    end)
  end

  test "generates the file for the resource test fixture with unique schema fields", config do
    in_tmp_project(config.test, fn ->
      args = ~w(Blog Post posts
            slug:string:unique
            subject:unique
            body:text:unique
            order:integer:unique
            price:decimal:unique
            published_at:utc_datetime:unique
            author:references:users:unique
            published?:boolean
          )

      contract = domain_contract_fixture(args)

      assert %DomainContract{} = DomainResourceAPI.generate_test_fixture(contract)

      assert_received {:mix_shell, :info,
                       [
                         """

                         Some of the generated database columns are unique. Please provide
                         unique implementations for the following fixture function(s) in
                         test/support/fixtures/domain/blog/post_fixtures.ex:

                             def unique_post_price do
                               raise "implement the logic to generate a unique post price"
                             end

                             def unique_post_published_at do
                               raise "implement the logic to generate a unique post published_at"
                             end
                         """
                       ]}

      assert_file("test/support/fixtures/domain/blog/post_fixtures.ex", fn file ->
        assert file =~ "defmodule ElixirScribe.Blog.PostFixtures do"
        assert file =~ ~S|def unique_post_order, do: System.unique_integer([:positive])|

        assert file =~
                 ~S|def unique_post_slug, do: "some slug#{System.unique_integer([:positive])}"|

        assert file =~
                 ~S|def unique_post_body, do: "some body#{System.unique_integer([:positive])}"|

        assert file =~
                 ~S|def unique_post_subject, do: "some subject#{System.unique_integer([:positive])}"|

        refute file =~ ~S|def unique_post_author|

        assert file =~ """
                 def unique_post_price do
                   raise "implement the logic to generate a unique post price"
                 end
               """

        assert file =~ """
                       body: unique_post_body(),
                       order: unique_post_order(),
                       price: unique_post_price(),
                       published?: true,
                       published_at: unique_post_published_at(),
                       slug: unique_post_slug(),
                       subject: unique_post_subject()
               """
      end)
    end)
  end
end
