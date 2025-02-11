defmodule ElixirScribe.Template.Module.BuildName.BuildAbsoluteModuleNameTest do
  alias ElixirScribe.Template.ModuleAPI
  use ElixirScribe.BaseCase, async: true

  describe "absolute module name for core file" do
    test "builds correctly for `file_type: :resource`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :resource) ===
               ElixirScribe.Site.Blog.Post
    end

    test "builds correctly for `file_type: :resource_test`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :resource_test) ===
               ElixirScribe.Site.Blog.Post
    end

    test "builds correctly for `file_type: :lib_core`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :lib_core) ===
               ElixirScribe.Site.Blog.Post
    end

    test "builds correctly for `file_type: :test_core`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :test_core) ===
               ElixirScribe.Site.Blog.Post
    end

    test "it returns nil for when the file type is HTML" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :html) === nil
    end
  end

  describe "absolute module name for web file" do
    test "builds correctly for `file_type: :lib_web`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :lib_web) ===
               ElixirScribeWeb.Site.Blog.Post
    end

    test "builds correctly for `file_type: :controller`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :controller) ===
               ElixirScribeWeb.Site.Blog.Post
    end

    test "builds correctly for `file_type: :controller_test`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :controller_test) ===
               ElixirScribeWeb.Site.Blog.Post
    end

    test "builds correctly for `file_type: :test_web`" do
      contract = domain_contract_fixture()

      assert ModuleAPI.build_absolute_module_name(contract, file_type: :test_web) ===
               ElixirScribeWeb.Site.Blog.Post
    end
  end

  test "it returns nil for `file_type: :test_web`" do
    contract = domain_contract_fixture()

    assert ModuleAPI.build_absolute_module_name(contract, file_type: :html) === nil
  end
end
