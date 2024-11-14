defmodule ElixirScribe.Template.Route.Scope.ScopeActionRoutesTest do
  alias ElixirScribe.Template.RouteAPI
  use ElixirScribe.BaseCase, async: true

  test "it builds the routes scope for all resource actions" do
    contract = domain_contract_fixture()

    expected_scope =
      """

        scope "/site/blog/posts", ElixirScribeWeb.Site.Blog.Post, as: :site_blog_posts do
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

    assert RouteAPI.scope_routes(contract) == expected_scope
  end
end
