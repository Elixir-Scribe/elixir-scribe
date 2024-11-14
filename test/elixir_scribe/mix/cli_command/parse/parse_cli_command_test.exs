defmodule ElixirScribe.Mix.CLICommand.Parse.ParseCLICommandTest do
  alias ElixirScribe.MixAPI
  use ElixirScribe.BaseCase, async: true

  describe "parse/1 successfully" do
    test "parses a CLI command without options" do
      args =
        expected_valid_args = [
          "Blog",
          "Post",
          "posts",
          "slug:unique"
        ]

      expected_opts = [
        resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
        schema: true,
        # context: true,
        no_default_actions: false,
        actions: nil,
        # binary_id: true,
        html_template: "default"
      ]

      assert {valid_args, all_opts, invalid_args} = MixAPI.parse_cli_command(args)

      assert_lists_equal(valid_args, expected_valid_args)
      assert_lists_equal(all_opts, expected_opts)
      assert invalid_args === []
    end

    test "parses a CLI command with options" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "--actions",
        "import,export"
      ]

      expected_valid_args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique"
      ]

      expected_opts = [
        resource_actions: [
          "list",
          "new",
          "read",
          "edit",
          "create",
          "update",
          "delete",
          "import",
          "export"
        ],
        schema: true,
        # context: true,
        no_default_actions: false,
        actions: "import,export",
        # binary_id: true,
        html_template: "default"
      ]

      assert {valid_args, all_opts, invalid_args} = MixAPI.parse_cli_command(args)

      assert_lists_equal(valid_args, expected_valid_args)
      assert_lists_equal(all_opts, expected_opts)
      assert invalid_args === []
    end

    test "parses a CLI command and returns unknown options as an invalid option" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "--unknown-option",
        "option-value"
      ]

      expected_invalid_args = [{"--unknown-option", nil}]

      assert {_valid_args, _all_opts, invalid_args} = MixAPI.parse_cli_command(args)
      assert_lists_equal(invalid_args, expected_invalid_args)
    end

    # @TODO I may need to open a bug in the ELixir OptionParser. Needs further investigation
    # test "parses the CLI command when the option value type doesn't match the one declared in @switches and returns it as an invalid option" do
    #     args = [
    #       "Blog",
    #       "Post",
    #       "posts",
    #       "slug:unique",
    #       "--prefix",
    #       # it's declared in @switches as a string value
    #       123
    #     ]

    #     expected_valid_args = [
    #       "Blog",
    #       "Post",
    #       "posts",
    #       "slug:unique",
    #       "secret:redact",
    #       "title:string"
    #     ]

    #     expected_invalid_args = [{:prefix, 123}]

    #     expected_opts = [
    #       resource_actions: ["list", "new", "read", "edit", "create", "update", "delete"],
    #       schema: true,
    #       context: true,
    #       no_default_actions: false,
    #       actions: nil,
    #       binary_id: true
    #     ]

    #     assert {_valid_args, _all_opts, invalid_args} = MixAPI.parse_cli_command(args)

    #     assert_lists_equal(invalid_args, expected_invalid_args)
    #   end
  end

  # describe ":binary_id option" do
  # test "its set to true by default" do
  #   args = [
  #     "Blog",
  #     "Post",
  #     "posts",
  #     "slug:unique"
  #   ]

  #   assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

  #   assert {:binary_id, true} in all_opts
  # end

  # test "can be set to false by using --no-binary-id" do
  #   args = [
  #     "Blog",
  #     "Post",
  #     "posts",
  #     "slug:unique",
  #     "--no-binary-id"
  #   ]

  #   assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

  #   assert {:binary_id, false} in all_opts
  # end
  # end

  describe ":resource_actions option" do
    test "by default is set to the ElixirScribe.resource_actions()" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique"
      ]

      assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

      assert {:resource_actions, ElixirScribe.resource_actions()} in all_opts
    end

    test "contains all actions passed by the --action flag in addition to the ElixirScribe.resource_actions()" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "--actions",
        "import,export"
      ]

      expected_actions = ElixirScribe.resource_actions() ++ ["import", "export"]

      assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

      assert {:resource_actions, expected_actions} in all_opts
    end

    test "only contains the actions passed by the --action flag when --no-default-actions is also provided" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "--actions",
        "import,export",
        "--no-default-actions"
      ]

      expected_actions = ["import", "export"]

      assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

      assert {:resource_actions, expected_actions} in all_opts
    end
  end

  describe ":context_app option" do
    test "it converts from string to atom" do
      args = [
        "Blog",
        "Post",
        "posts",
        "slug:unique",
        "--context-app",
        "marketing"
      ]

      assert {_valid_args, all_opts, _invalid_args} = MixAPI.parse_cli_command(args)

      assert :marketing = Keyword.get(all_opts, :context_app)
    end
  end
end
