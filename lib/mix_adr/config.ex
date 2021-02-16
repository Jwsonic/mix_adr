defmodule MixAdr.Config do
  @moduledoc """
  Configuration struct and loading logic for mix_adr configuration.
  """

  defstruct adr_dir: nil, template_file: nil

  @type t() :: %__MODULE__{
          adr_dir: String.t(),
          template_file: String.t()
        }

  @doc """
  Creates a `MixAdr.Config` struct. First tries to load from the application config,
  will then fall back to default values.
  """

  @spec load() :: {:ok, t()} | {:error, String.t()}
  def load do
    with {:ok, adr_dir} <- load_dir(),
         {:ok, template_file} <- load_template_file() do
      {:ok,
       %__MODULE__{
         adr_dir: adr_dir,
         template_file: template_file
       }}
    end
  end

  @dir_default "docs/adr"

  defp load_dir do
    :mix_adr
    |> Application.get_env(:adr_dir, @dir_default)
    |> case do
      dir when is_bitstring(dir) -> {:ok, dir}
      other -> {:error, "Invalid ADR directory: #{inspect(other)}"}
    end
  end

  @template_simple "priv/templates/simple.eex"
  @template_advanced "priv/templates/advanced.eex"

  defp load_template_file do
    :mix_adr
    |> Application.get_env(:template_file, :simple)
    |> case do
      :simple -> {:ok, @template_simple}
      :advanced -> {:ok, @template_advanced}
      file when is_bitstring(file) -> {:ok, file}
      other -> {:error, "Invalid template file: #{inspect(other)}"}
    end
  end
end
