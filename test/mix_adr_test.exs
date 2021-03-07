defmodule FilesTest do
  use ExUnit.Case, async: false

  alias MixAdr

  @adr_dir Path.join(System.tmp_dir!(), "/mix_adr_test")

  setup do
    clean!()
  end

  defp clean! do
    if File.exists?(@adr_dir) do
      File.rm_rf!(@adr_dir)
    end

    File.mkdir_p!(@adr_dir)
  end

  describe "MixAdr.init!/1" do
    test "It fails if the ADR dir already exists"
    test "It creates the ADR dir if one does not already exist"
    test "It creates and initial ADR file"
  end
end
