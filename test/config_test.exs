defmodule ConfigTest do
  use ExUnit.Case, async: false
  doctest MixAdr

  alias MixAdr.Config

  describe "Config.load/0" do
    setup do
      # Clean out application configs between tests
      on_exit(fn ->
        Enum.each([:adr_dir, :template_file], fn key ->
          :ok = Application.delete_env(:mix_adr, key)
        end)
      end)
    end

    test "it loads the correct Config from the applciation config" do
      assert Config.load() ==
               {:ok,
                %Config{
                  adr_dir: "docs/adr",
                  template_file: "priv/templates/simple.eex"
                }}
    end

    test "it provides default values" do
      adr_dir = System.tmp_dir!() |> Path.join("adr")
      template_file = "priv/templates/simple.eex"

      :ok = Application.put_env(:mix_adr, :adr_dir, adr_dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert Config.load() ==
               {:ok,
                %Config{
                  adr_dir: adr_dir,
                  template_file: template_file
                }}
    end

    test "it returns an error if incorrect value types are provided" do
      adr_dir = System.tmp_dir!() |> Path.join("adr")
      template_file = 1234

      :ok = Application.put_env(:mix_adr, :adr_dir, adr_dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert Config.load() == {:error, "Invalid template file: 1234"}

      adr_dir = :bad_atom
      template_file = "priv/templates/simple.eex"

      :ok = Application.put_env(:mix_adr, :adr_dir, adr_dir)
      :ok = Application.put_env(:mix_adr, :template_file, template_file)

      assert Config.load() == {:error, "Invalid ADR directory: :bad_atom"}
    end
  end
end
