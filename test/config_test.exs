defmodule ConfigTest do
  use ExUnit.Case, async: false
  doctest MixAdr

  alias MixAdr.Config

  describe "Config.load!/0" do
    setup do
      # Clean out application configs between tests
      on_exit(fn ->
        :mix_adr
        |> Application.get_all_env()
        |> Keyword.keys()
        |> Enum.each(&Application.delete_env(:mix_adr, &1))
      end)
    end

    test "it loads the correct Config from the applciation config" do
      assert Config.load!() |> Enum.sort() ==
               [
                 dir: "docs/adr",
                 template_file:
                   "/storage/workspace/mix_adr/_build/test/lib/mix_adr/priv/templates/simple.eex"
               ]
    end

    test "it provides default values" do
      dir = System.tmp_dir!() |> Path.join("adr")
      template_file = "priv/templates/simple.eex"

      :ok = Application.put_env(:mix_adr, :dir, dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert Config.load!() |> Enum.sort() ==
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

    test "it ignores unecessary keys" do
      :ok = Application.put_env(:mix_adr, :fake_key, 1234)

      assert Config.load!() |> Enum.sort() ==
               [
                 dir: "docs/adr",
                 template_file:
                   "/storage/workspace/mix_adr/_build/test/lib/mix_adr/priv/templates/simple.eex"
               ]
    end
  end

  describe "Config.new!/0" do
    test "it creates a new config when given proper params" do
      template_file =
        :mix_adr
        |> :code.priv_dir()
        |> Path.join("templates/simple.eex")

      assert Keyword.equal?(
               [
                 {:template_file, template_file},
                 {:dir, "docs/adr"}
               ],
               Config.new!()
             )

      assert Keyword.equal?(
               [
                 {:template_file, template_file},
                 {:dir, "test/dir"}
               ],
               Config.new!(dir: "test/dir")
             )

      assert Keyword.equal?(
               [
                 {:template_file, "test_file.eex"},
                 {:dir, "docs/adr"}
               ],
               Config.new!(template_file: "test_file.eex")
             )

      assert Keyword.equal?(
               [
                 {:template_file, "test_file.eex"},
                 {:dir, "test/dir"}
               ],
               Config.new!(dir: "test/dir", template_file: "test_file.eex")
             )
    end

    test "it fails when given incorrect params" do
      assert_raise(NimbleOptions.ValidationError, fn -> Config.new!(dir: 1) end)
    end
  end
end
