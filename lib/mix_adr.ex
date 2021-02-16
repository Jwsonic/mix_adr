defmodule MixAdr do
  @moduledoc """
  Documentation for `MixAdr`.
  """

  alias MixAdr.{Config, Files}

  @doc """
  Creates the ADR directory and writes an initial ADR.
  """
  def init(%Config{adr_dir: adr_dir} = config) do
    File.mkdir_p!(adr_dir)

    Files.create("adopt adrs", "", config)
  end
end
