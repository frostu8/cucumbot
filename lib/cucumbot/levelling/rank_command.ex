defmodule Cucumbot.Levelling.RankCommand do
  use Cucumbot.Command.Handler, name: "rank"

  alias Cucumbot.Command.Context, as: CommandCtx
  alias Cucumbot.Levelling.Store

  alias Nostrum.Api
  alias Nostrum.Cache.UserCache

  def execute(ctx) do
    case CommandCtx.next_user(ctx) do
      {nil, ctx} -> 
        user = Nostrum.Cache.UserCache.get!(ctx.msg.author.id)

        get_user_level(ctx, user)
      {:error, arg, ctx} -> 
        Api.create_message!(ctx.msg.channel_id,
          "Could not find user #{arg}!")
      {user, ctx} -> 
        get_user_level(ctx, user)
    end
  end

  defp get_user_level(ctx, user) do
    # get user
    dscore = Store.get_or_default(user.id, ctx.msg.guild_id)

    # get level
    level = Cucumbot.Levelling.score_to_level(dscore.score)

    # print results
    Api.create_message!(ctx.msg.channel_id, 
      "#{user.username} is at lv#{level} with #{dscore.score} score.")
  end
end
