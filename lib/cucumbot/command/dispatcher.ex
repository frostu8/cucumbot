defmodule Cucumbot.Command.Dispatcher do
  @moduledoc """
  Dispatches commands.
  """

  @prefix "!"

  @commands [
    Cucumbot.About,
    Cucumbot.Levelling.RankCommand
  ]

  use Nostrum.Consumer

  alias Cucumbot.Command.Arguments, as: CommandArgs

  @spec handle_message(Nostrum.Struct.Message.t) :: :ok | :ignore
  def handle_message(msg) do
    # only handle if commands are being executed in a guild
    if msg.guild_id do
      case strip_prefix(msg.content, @prefix) do
        nil ->
          # skip non command
          :ignore
        command ->
          {cmd, args} = CommandArgs.next_arg(command)

          dispatch(cmd, args, msg)
      end
    end
  end

  @spec dispatch(String.t, CommandArgs.t, Nostrum.Struct.Message.t) :: no_return
  defp dispatch(cmd, args, msg) do
    # handle command
    command = @commands |> Enum.find(
      fn handler -> Keyword.fetch!(handler.info(), :name) === cmd end)

    case command do
      nil ->
        # ignore nonexistant command
        :ignore
      handler ->
        # execute handler
        handler.execute(args, msg)
    end
  end

  @spec strip_prefix(String.t, String.t) :: String.t | nil
  defp strip_prefix(msg, prefix) do
    if String.starts_with?(msg, prefix) do
      String.slice(msg, String.length(prefix)..-1)
    else
      nil
    end
  end
end
