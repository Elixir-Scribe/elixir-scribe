Code.require_file("test/mix_test_helper.exs")

defmodule Mix.Tasks.Scribe.Gen.DomainSyncTest do
  use ElixirScribe.BaseCase

  import MixTestHelper

  setup do
    Mix.Task.clear()
    :ok
  end

  # test "it raises when inside in umbrella project", config do
  #   in_tmp_umbrella_project(config.test, fn ->
  #     assert_raise Mix.Error, ~r/No arguments were provided.*$/s, fn ->
  #       Mix.Tasks.Scribe.Gen.Domain.run(~w(blog Post posts title:string))
  #     end
  #   end)
  # end

  test "it generates the domain resource", config do
    in_tmp_project(config.test, fn ->
      assert :ok = Mix.Tasks.Scribe.Gen.Domain.run(~w(Blog Post posts title:string))

      assert_received {:mix_shell, :info,
                       [
                         "\nRemember to update your repository by running migrations:\n\n    $ mix ecto.migrate\n"
                       ]}
    end)
  end
end
