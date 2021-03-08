defmodule MixAdr.Template do
  @moduledoc """
  The Template module contans functions for the building and validations of ADRs based off of a template file.
  """

  @schema_args [
    consequences: [
      type: :string,
      default: "What becomes easier or more difficult to do because of this change?",
      doc: "The consequences of adopting the current ADR."
    ],
    context: [
      type: :string,
      default: "What is the issue that we're seeing that is motivating this decision or change?",
      doc: "The context around the decision being made"
    ],
    decision: [
      type: :string,
      default: "What is the change that we're proposing and/or doing?",
      doc: "The change or decision being proposed."
    ],
    id: [
      type: :integer,
      required: true,
      doc: "The id of the current ADR."
    ],
    status: [
      type: :string,
      default:
        "What is the status? Such as: proposed, accepted, rejected, deprecated, superseded, etc.?",
      doc: "The status of the current ADR."
    ],
    title: [
      type: :string,
      required: true,
      doc: "The title of the current ADR."
    ]
  ]

  @spec schema() :: list()
  def schema do
    @schema_args
  end

  @doc "Creates ADR file contents based on the given arguments. Supported arguments:\n#{
         NimbleOptions.docs(@schema_args)
       }"
  @spec eval!(args :: list(), config :: Config.t()) :: String.t()
  def eval!(args, config) when is_list(args) do
    args
    |> validate!()
    |> add_date()
    |> eval(config)
  end

  defp validate!(args) do
    NimbleOptions.validate!(args, @schema_args)
  end

  defp add_date(args) do
    date = Date.utc_today() |> Date.to_string()

    Keyword.put(args, :date, date)
  end

  defp eval(args, config) do
    config
    |> Config.template!()
    |> EEx.eval_file(args)
  end
end
