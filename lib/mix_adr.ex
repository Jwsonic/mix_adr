defmodule MixAdr do
  @moduledoc """
  Documentation for `MixAdr`.
  """

  alias MixAdr.{Config, Files}

  @template "priv/templates/simple.eex"
  @external_resource @template

  @args_init [
    consequences:
      "See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).",
    context: "We need to record the architectural decisions made on this project.",
    decision:
      "We will use Architecture Decision Records, as [described by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).",
    status: "Accepted",
    title: "Record architecture decisions"
  ]

  @doc """
  Creates the ADR directory and writes an initial ADR.
  """
  @spec init!(config :: Config.t()) :: :ok
  def init!(config) do
    adr_dir = Config.adr_dir!(config)

    if File.exists?(adr_dir) do
      raise "ADR dir: #{adr_dir} already exists"
    end

    File.mkdir_p!(adr_dir)

    Files.create!(@args_init, config)
  end

  @spec new!(config :: Config.t()) :: :ok
  def new!(config) do
    :ok
  end
end
