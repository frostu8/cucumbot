defmodule Cucumbot.Invoker do
  @prefix "!"

  @commands [
    Cucumbot.Cogs.About,
    Cucumbot.Cogs.Rank
  ]

  alias Cucumbot.Arguments

  @spec handle_message(Nostrum.Struct.Message.t) :: no_return
  def handle_message(msg) do
    if String.starts_with?(msg.content, @prefix) do
      command = String.slice(msg.content, String.length(@prefix)..-1)
      {cmd, args} = Arguments.next_arg(command)

      dispatch_command(cmd, args, msg)
    else
      # skip non command
      :ignore
    end
  end

  @spec dispatch_command(String.t, Arguments.t, Nostrum.Struct.Message.t) :: no_return
  defp dispatch_command(cmd, args, msg) do
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
end
