defmodule MixAdr.Files do
  @moduledoc """
  Module for dealing with ADR files directly.
  """

  alias MixAdr.Config

  @spec init() :: :ok | {:error, String.t()}
  def init do
    :ok
  end

  @doc """
  Creates a new ADR file with a name like "\#{id}_\#{slug}.md". Where id is a generated integer.
  """
  @spec create(title :: String.t(), content :: String.t(), config :: Config.t()) ::
          :ok | {:error, String.t()}
  def create(title, content, %Config{} = config)
      when is_bitstring(title) and is_bitstring(content) do
    with {:ok, file_path} <- build_file_path(title, config) do
      File.write(file_path, content)
    end
  end

  defp build_file_path(title, %Config{adr_dir: adr_dir} = config) do
    with {:ok, id} <- next_id(config) do
      slug = Macro.underscore(title)

      {:ok, Path.join(adr_dir, "#{id}_#{slug}.md")}
    end
  end

  @regex_id ~r/^(\d+)_.+\.md$/

  defp next_id(%Config{adr_dir: adr_dir}) do
    with {:ok, files} <- File.ls(adr_dir) do
      id = max_id(files) + 1

      {:ok, String.pad_leading("#{id}", 4, "0")}
    end
  end

  defp max_id(files), do: max_id(files, 0)

  defp max_id([], count), do: count

  defp max_id([file_name | rest], count) do
    new_count =
      with [_full, number] <- Regex.run(@regex_id, file_name),
           {id, _rem} <- Integer.parse(number) do
        max(id, count)
      else
        _ -> count
      end

    max_id(rest, new_count)
  end
end
