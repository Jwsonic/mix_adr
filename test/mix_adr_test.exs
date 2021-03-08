defmodule MixAdrTest do
  use ExUnit.Case, async: false

  alias MixAdr
  alias MixAdr.Config

  @adr_dir Path.join(System.tmp_dir!(), "/mix_adr_test")
  @config Config.new!(dir: @adr_dir)

  describe "MixAdr.init!/1" do
    setup do
      clean!()

      :ok
    end

    defp clean! do
      if File.exists?(@adr_dir) do
        File.rm_rf!(@adr_dir)
      end
    end

    test "It fails if the ADR dir already exists" do
      if !File.exists?(@adr_dir) do
        File.mkdir_p!(@adr_dir)
      end

      assert_raise(RuntimeError, fn -> MixAdr.init!(@config) end)
    end

    test "It creates the ADR dir if one does not already exist" do
      MixAdr.init!(@config)

      assert File.exists?(@adr_dir)
    end

    test "It creates and initial ADR file" do
      MixAdr.init!(@config)

      assert @adr_dir
             |> Path.join("0001_record_architecture_decisions.md")
             |> File.exists?()
    end
  end
end
