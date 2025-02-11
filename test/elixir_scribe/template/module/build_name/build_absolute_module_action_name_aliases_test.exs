defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleActionNameAliasesTest do
  alias ElixirScribe.Template.ModuleAPI

  use ElixirScribe.BaseCase, async: true

  test "it builds the module alias for each resource action" do
    contract = domain_contract_fixture()

    expected_aliases =
      """

        alias ElixirScribe.Site.Blog.Post.List.ListPosts
        alias ElixirScribe.Site.Blog.Post.New.NewPost
        alias ElixirScribe.Site.Blog.Post.Read.ReadPost
        alias ElixirScribe.Site.Blog.Post.Edit.EditPost
        alias ElixirScribe.Site.Blog.Post.Create.CreatePost
        alias ElixirScribe.Site.Blog.Post.Update.UpdatePost
        alias ElixirScribe.Site.Blog.Post.Delete.DeletePost
      """
      |> String.trim_trailing()

    assert ModuleAPI.build_absolute_module_action_name_aliases(contract,
             file_type: :lib_core
           ) === expected_aliases
  end
end
