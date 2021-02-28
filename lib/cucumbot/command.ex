defmodule Cucumbot.Command do
  @moduledoc """
  Command handling logic.
  """

  @prefix "!"

  @commands [
    Cucumbot.About
  ]

  use Nostrum.Consumer

  alias Cucumbot.Command.Context, as: CommandCtx

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case CommandCtx.parse(msg, @prefix) do
      nil ->
        # skip non command
        :ignore
      command ->
        # handle command
        case @commands |> Enum.find(fn handler -> handler.name === command.cmd end) do
          nil ->
            # ignore nonexistant command
            :ignore
          handler ->
            # execute handler
            handler.execute(command)
        end
    end
  end

  def handle_event(_event) do
    :noop
  end
end