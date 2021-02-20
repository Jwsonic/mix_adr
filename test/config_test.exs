defmodule ConfigTest do
  use ExUnit.Case, async: false
  doctest MixAdr

  alias MixAdr.Config

  describe "Config.load/0" do
    setup do
      # Clean out application configs between tests
      on_exit(fn ->
        Enum.each([:dir, :template_file], fn key ->
          :ok = Application.delete_env(:mix_adr, key)
        end)
      end)
    end

    test "it loads the correct Config from the applciation config" do
      assert Config.load!() ==
               [
                 template_file:
                   "/storage/workspace/mix_adr/_build/test/lib/mix_adr/priv/templates/simple.eex",
                 dir: "docs/adr"
               ]
    end

    test "it provides default values" do
      dir = System.tmp_dir!() |> Path.join("adr")
      template_file = "priv/templates/simple.eex"

      :ok = Application.put_env(:mix_adr, :dir, dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert Config.load!() ==
               [dir: dir, template_file: template_file]
    end

    test "it returns an error if incorrect value types are provided" do
      dir = System.tmp_dir!() |> Path.join("adr")
      template_file = 1234

      :ok = Application.put_env(:mix_adr, :dir, dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert_raise NimbleOptions.ValidationError,
                   "expected :template_file to be a string, got: #{template_file}",
                   &Config.load!/0

      dir = :bad_atom
      template_file = "priv/templates/simple.eex"

      :ok = Application.put_env(:mix_adr, :dir, dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert_raise NimbleOptions.ValidationError,
                   "expected :dir to be a string, got: :bad_atom",
                   &Config.load!/0
    end
  end
end
