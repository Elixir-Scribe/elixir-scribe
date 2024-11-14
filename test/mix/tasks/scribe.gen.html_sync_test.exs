Code.require_file("test/mix_test_helper.exs")

defmodule Mix.Tasks.Scribe.Gen.HtmlSyncTest do
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  test "it generates the lib and test domain resources for my_app_web and my_app",
       config do
    in_tmp_project(config.test, fn ->
      args = ~w(Blog Post posts
        title:string
        slug:unique
        votes:integer
        cost:decimal
        tags:array:text
        popular:boolean
        drafted_at:datetime
        status:enum:unpublished:published:deleted
        published_at:utc_datetime
        published_at_usec:utc_datetime_usec
        deleted_at:naive_datetime
        deleted_at_usec:naive_datetime_usec
        alarm:time
        alarm_usec:time_usec
        secret:uuid:redact
        announcement_date:date
        alarm:time
        metadata:map
        weight:float
        user_id:references:users)

      assert :ok = Mix.Tasks.Scribe.Gen.Html.run(args)

      assert File.exists?(
               "lib/elixir_scribe_web/domain/blog/post/create/create_post_controller.ex"
             )

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/create/create_post_controller_test.exs"
             )

      assert File.exists?(
               "lib/elixir_scribe_web/domain/blog/post/delete/delete_post_controller.ex"
             )

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/delete/delete_post_controller_test.exs"
             )

      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/edit/edit_post_controller.ex")
      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/edit/edit_post.html.heex")

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/edit/edit_post_controller_test.exs"
             )

      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/list/list_posts_controller.ex")
      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/list/list_posts.html.heex")

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/list/list_posts_controller_test.exs"
             )

      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/new/new_post_controller.ex")
      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/new/new_post.html.heex")

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/new/new_post_controller_test.exs"
             )

      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/read/read_post_controller.ex")
      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/read/read_post.html.heex")

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/read/read_post_controller_test.exs"
             )

      assert File.exists?(
               "lib/elixir_scribe_web/domain/blog/post/update/update_post_controller.ex"
             )

      assert File.exists?(
               "test/elixir_scribe_web/domain/blog/post/update/update_post_controller_test.exs"
             )

      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/post_form.html.heex")
      assert File.exists?("lib/elixir_scribe_web/domain/blog/post/post_html.ex")

      ### LIB CORE - DOMAIN RESOURCE ACTIONS ####
      # The domain generator is also invoked by mix scribe.gen.html

      assert File.exists?("lib/elixir_scribe/domain/blog/post/post_schema.ex")

      assert File.exists?("lib/elixir_scribe/domain/blog/post_api.ex")

      assert File.exists?("lib/elixir_scribe/domain/blog/post/list/list_posts.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/list/list_posts_test.exs")

      assert File.exists?("lib/elixir_scribe/domain/blog/post/new/new_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/new/new_post_test.exs")

      assert File.exists?("lib/elixir_scribe/domain/blog/post/read/read_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/read/read_post_test.exs")

      assert File.exists?("lib/elixir_scribe/domain/blog/post/edit/edit_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/edit/edit_post_test.exs")

      assert File.exists?("lib/elixir_scribe/domain/blog/post/create/create_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/create/create_post_test.exs") ===
               true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/update/update_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/update/update_post_test.exs") ===
               true

      assert File.exists?("lib/elixir_scribe/domain/blog/post/delete/delete_post.ex")

      assert File.exists?("test/elixir_scribe/domain/blog/post/delete/delete_post_test.exs") ===
               true

      ### TEST FIXTURES ###

      assert File.exists?("test/support/fixtures/domain/blog/post_fixtures.ex")

      ### MIGRATIONS ###

      assert Path.wildcard("priv/repo/migrations/*_create_posts.exs") |> length() === 1

      expected_routes = """

      Your Blog :browser scope in lib/elixir_scribe_web/router.ex should now look like this:

        scope "/blog/posts", ElixirScribeWeb.Blog.Post, as: :blog_posts do
          pipe_through :browser

          get "/", List.ListPostsController, :list
          get "/new", New.NewPostController, :new
          get "/:id", Read.ReadPostController, :read
          get "/:id/edit", Edit.EditPostController, :edit
          post "/", Create.CreatePostController, :create
          patch "/:id", Update.UpdatePostController, :update
          put "/:id", Update.UpdatePostController, :update
          delete "/:id", Delete.DeletePostController, :delete
        end
      """

      expected_migrations_info = """

      Remember to update your repository by running migrations:

          $ mix ecto.migrate
      """

      assert_receive {:mix_shell, :info, [^expected_routes]}
      assert_receive {:mix_shell, :info, [^expected_migrations_info]}
    end)
  end
end
