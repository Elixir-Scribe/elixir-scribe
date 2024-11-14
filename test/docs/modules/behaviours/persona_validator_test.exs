defmodule PersonaValidatorTest do
  use ElixirScribe.BaseCase, async: true

  # This validator is used as part of the Persona module in the docs for the
  # typed contract, therefore not a strict validator that needs to be exhaustively tested.

  describe "corporate_email?/1" do
    test "returns true with valid corporate email" do
      assert PersonaValidator.corporate_email?("me@company.com")
    end

    test "returns false with valid personal email" do
      refute PersonaValidator.corporate_email?("me@gmail.com")
    end

    test "returns false with invalid email format" do
      refute PersonaValidator.corporate_email?("me@")
      refute PersonaValidator.corporate_email?("megmail.com")
    end

    test "returns false when the email isn't a string" do
      refute PersonaValidator.corporate_email?(["me@company.com"])
    end
  end

  describe "role?/1" do
    test "it returns true when the optional role attribute it's nil" do
      assert PersonaValidator.role?(nil)
    end

    test "it returns true when the role is a string with at least three characters" do
      assert PersonaValidator.role?("dev")
    end

    test "it returns false when the role is a string with less then three characters" do
      refute PersonaValidator.role?("dv")
    end

    test "it returns false when the role isn't a string" do
      refute PersonaValidator.role?(:dev)
    end
  end
end
