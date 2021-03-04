defmodule Cucumbot.Levelling.RankCommand do
  use Cucumbot.Command, name: "rank"

  alias Cucumbot.Command.Arguments, as: CommandArgs
  alias Cucumbot.Levelling.Store

  alias Nostrum.Api
  alias Nostrum.Cache.UserCache

  def execute(args, msg) do
    user_id = case CommandArgs.next_arg(args) do
      {nil, args} ->
        msg.author.id
      {user_mention, args} ->
        Cucumbot.Util.User.resolve_mention(user_mention)
    end
  end
end
