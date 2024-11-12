defmodule Mix.Tasks.Scribe.Gen.DomainAsyncTest do
  use ElixirScribe.BaseCase, async: true

  test "It raises when no arguments are provided" do
    assert_raise Mix.Error, ~r/No arguments were provided.*$/s, fn ->
      Mix.Tasks.Scribe.Gen.Domain.run([])
    end
  end
end
