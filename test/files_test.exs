defmodule FilesTest do
  use ExUnit.Case, async: false

  alias MixAdr.{Config, Files}

  @adr_dir Path.join(System.tmp_dir!(), "/mix_adr_test")
  @config Config.new!(dir: @adr_dir)

  describe "Files.create/1" do
    setup do
      clean!()
    end

    # Provides a clean test dir
    defp clean! do
      if File.exists?(@adr_dir) do
        File.rm_rf!(@adr_dir)
      end

      File.mkdir_p!(@adr_dir)
    end

    test "it creates files with names increasing in order" do
      Enum.each(1..9, fn id ->
        Files.create("test", "", @config)

        assert largest_file!() ==
                 "000#{id}_test.md"
      end)

      Files.create("test", "", @config)

      assert largest_file!() ==
               "0010_test.md"
    end

    test "it creates files with underscored names"

    test "it properly pads the id to four digits" do
      touch!("0009_test.md")

      Files.create("test", "", @config)

      assert largest_file!() ==
               "0010_test.md"

      touch!("0099_test.md")

      Files.create("test", "", @config)

      assert largest_file!() ==
               "0100_test.md"

      touch!("0999_test.md")

      Files.create("test", "", @config)

      assert largest_file!() ==
               "1000_test.md"
    end

    test "it creates a file with an id of current + 1" do
      1..1000
      |> Enum.random()
    end

    # Returns the largest numbered file from the ADR dir
    defp largest_file! do
      @adr_dir
      |> File.ls!()
      |> Enum.sort()
      |> Enum.reverse()
      |> List.first()
    end

    defp touch!(file_name) do
      @adr_dir
      |> Path.join(file_name)
      |> File.touch!()
    end
  end
end
