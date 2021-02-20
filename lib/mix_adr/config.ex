defmodule MixAdr.Config do
  @moduledoc """
  Configuration struct and loading logic for mix_adr configuration.
  """

  defstruct adr_dir: nil, template_file: nil

  @schema [
    dir: [
      type: :string,
      default: "docs/adr"
    ],
    template_file: [
      type: :string,
      default:
        :mix_adr
        |> :code.priv_dir()
        |> Path.join("templates/simple.eex")
    ]
  ]

  @opaque t() :: keyword()

  @doc """
  Creates a `MixAdr.Config`. First tries to load from the application config,
  will then fall back to default values.
  """

  @spec load!() :: {:ok, t()} | {:error, String.t()}
  def load! do
    :mix_adr
    |> Application.get_all_env()
    |> NimbleOptions.validate!(@schema)
  end
end
