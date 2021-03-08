defmodule MixAdr.Config do
  @moduledoc """
  Configuration struct and loading logic for mix_adr configuration.
  """

  @opaque t() :: keyword()

  @spec new!(args :: keyword()) :: t()
  def new!(args \\ []) when is_list(args) do
    validate!(args)
  end

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

  @allowed_keys Keyword.keys(@schema)

  defp validate!(args) do
    args
    |> Keyword.take(@allowed_keys)
    |> NimbleOptions.validate!(@schema)
  end

  @doc """
  Creates a `MixAdr.Config`. First tries to load from the application config,
  will then fall back to default values.
  """
  @spec load!() :: t()
  def load! do
    :mix_adr
    |> Application.get_all_env()
    |> validate!()
  end

  @spec adr_dir!(config :: t()) :: String.t()
  def adr_dir!(config) when is_list(config) do
    config |> validate!() |> Keyword.fetch!(:dir)
  end

  @spec template!(config :: t()) :: String.t()
  def template!(config) when is_list(config) do
    config |> validate!() |> Keyword.fetch!(:template)
  end
end
