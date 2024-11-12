defmodule ElixirScribe.Template.File.BuildPathForHtml.BuildPathForHtmlFileTest do
  alias ElixirScribe.Template.FileAPI

  use ElixirScribe.BaseCase, async: true

  test "it builds the directory path for the default HTML template" do
    args = ["Site.Blog", "Post", "posts", "name:string", "desc:string"]
    contract = domain_contract_fixture(args)

    assert FileAPI.build_dir_path_for_html_file(contract) ===
             "priv/templates/scribe.gen.html/html/default"
  end

  test "it builds the directory path for a custom HTML template" do
    args = [
      "Site.Blog",
      "Post",
      "posts",
      "name:string",
      "desc:string",
      "--html-template",
      "online_shop"
    ]

    contract = domain_contract_fixture(args)

    assert FileAPI.build_dir_path_for_html_file(contract) ===
             "priv/templates/scribe.gen.html/html/online_shop"
  end
end
