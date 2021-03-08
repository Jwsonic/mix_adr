defmodule MixAdr.Files do
  @moduledoc """
  Module for manipulating ADR files on disk.
  """

  alias MixAdr.{Config, Template}

  @doc """
  Creates a new ADR file with a name like "\#{id}_\#{slug}.md". Where id is a generated integer. Supported arguments:\n#{
    NimbleOptions.docs(Template.schema())
  }"
  """
  @spec create!(args :: list(), config :: Config.t()) :: :ok
  def create!(args, config) when is_list(args) do
    args
    |> add_id!(config)
    |> build_content!(config)
    |> write_file!(config)
  end

  @regex_id ~r/^(\d+)_.+\.md$/

  defp add_id!(args, config) do
    adr_dir = Config.adr_dir!(config)
    id = adr_dir |> File.ls!() |> max_id() |> Kernel.+(1)

    Keyword.put(args, :id, id)
  end

  defp build_content!(args, config) do
    content = Template.eval!(args, config)

    Keyword.put(args, :content, content)
  end

  defp write_file!(args, config) do
    adr_dir = Config.adr_dir!(config)
    id = args |> Keyword.fetch!(:id) |> to_string() |> String.pad_leading(4, "0")
    slug = args |> Keyword.fetch!(:title) |> String.downcase() |> String.replace(" ", "_")
    file_path = Path.join(adr_dir, "#{id}_#{slug}.md")
    content = Keyword.fetch!(args, :content)

    File.write!(file_path, content)
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
