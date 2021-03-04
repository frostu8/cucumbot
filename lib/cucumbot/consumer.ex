defmodule Cucumbot.Consumer do
  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # handle exp
    Cucumbot.Levelling.handle_message(msg)

    # attempt to dispatch command
    Cucumbot.Command.Dispatcher.handle_message(msg)
  end

  def handle_event(_event) do
    :noop
  end
end
