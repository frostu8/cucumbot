defmodule Cucumbot.Command do
  @moduledoc """
  Command handling logic.
  """

  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do

  end

  def handle_event(_event) do
    :noop
  end
end
