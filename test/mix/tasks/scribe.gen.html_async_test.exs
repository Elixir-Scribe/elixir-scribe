defmodule Mix.Tasks.Scribe.Gen.HtmlAsyncTest do
  use ElixirScribe.BaseCase, async: true

  test "It raises when no arguments are provided" do
    assert_raise Mix.Error, ~r/No arguments were provided.*$/s, fn ->
      Mix.Tasks.Scribe.Gen.Html.run([])
    end
  end
end
