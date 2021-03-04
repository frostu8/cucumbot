defmodule Cucumbot.Consumer do
  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # handle exp
    Cucumbot.Score.handle_message(msg)

    # attempt to dispatch command
    Cucumbot.CommandInvoker.handle_message(msg)
  end

  def handle_event(_event) do
    :noop
  end
end
