defmodule Cucumbot.Command do
  @moduledoc """
  Command handling logic.
  """

  @prefix "!"

  @commands [
    Cucumbot.About,
    Cucumbot.Levelling.RankCommand
  ]

  use Nostrum.Consumer

  alias Cucumbot.Command.Context, as: CommandCtx

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # only handle if commands are being executed in a guild
    if msg.guild_id do
      case CommandCtx.parse(msg, @prefix) do
        nil ->
          # skip non command
          # add EXP though
          Cucumbot.Levelling.handle_message(msg)
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
  end

  def handle_event(_event) do
    :noop
  end
end
