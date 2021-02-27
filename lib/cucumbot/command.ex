defmodule Cucumbot.Command do
  @moduledoc """
  Command handling logic.
  """

  @prefix "!"

  use Nostrum.Consumer

  alias Nostrum.Api

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
        handle_command(command)
    end
  end

  def handle_event(_event) do
    :noop
  end

  @spec handle_command(CommandCtx.t) :: no_return
  def handle_command(context) do
    case context |> Map.get(:cmd) do
      "about" ->
        Api.create_message(context.msg.channel_id, "Cucumbot")
      _ ->
        # ignore non-existant command
        :ignore
    end
  end
end
