defmodule Mix.Tasks.Adr.Init do
  use Mix.Task

  @shortdoc "Mix task for initiailizing ADRs in a project."
  @moduledoc @shortdoc

  @doc false
  def run(_argv) do
    MixAdr.Config.load!() |> MixAdr.init!()
  end
end
