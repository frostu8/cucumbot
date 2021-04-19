defmodule Cucumbot.Consumer do
  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _state, _ws_state}) do
    Cucumbot.Invoker.register_commands()
  end

  def handle_event({:INTERACTION_CREATE, intr, _ws_state}) do
    Cucumbot.Invoker.dispatch_command(intr)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # only execute the following statements if we are in a guild and this isn't
    # a bot's message
    if msg.guild_id do
      unless msg.author.bot do
        # handle exp
        Cucumbot.Score.handle_message(msg)
      end
    end
  end

  def handle_event(_event) do
    :noop
  end
end
