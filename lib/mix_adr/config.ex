defmodule MixAdr.Config do
  @moduledoc """
  Configuration struct and loading logic for mix_adr configuration.
  """

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

  @spec new!(args :: keyword()) :: t()
  def new!(args \\ []) when is_list(args) do
    args
    |> filter_allowed(@schema)
    |> NimbleOptions.validate!(@schema)
  end

  defp filter_allowed(args, @schema) do
    allowed_keys = Keyword.keys(@schema)

    Enum.filter(args, fn {key, _value} -> Enum.member?(allowed_keys, key) end)
  end

  @doc """
  Creates a `MixAdr.Config`. First tries to load from the application config,
  will then fall back to default values.
  """
  @spec load!() :: t()
  def load! do
    :mix_adr
    |> Application.get_all_env()
    |> new!()
  end

  @spec adr_dir!(config :: t()) :: String.t()
  def adr_dir!(config) when is_list(config) do
    Keyword.fetch!(config, :dir)
  end
end
