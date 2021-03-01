defmodule Cucumbot.Levelling.RankCommand do
  use Cucumbot.Command.Handler, name: "rank"

  alias Cucumbot.Command.Context, as: CommandCtx
  alias Cucumbot.Levelling.Store

  def execute(ctx) do
    user_id = case CommandCtx.next_arg(ctx) do
      {nil, _ctx} -> ctx.msg.author.id
      {_user, _ctx} -> raise "Unimplemented"
    end

    # get user
    dscore = Store.get_or_default(user_id, ctx.msg.guild_id)

    # get level
    level = Cucumbot.Levelling.score_to_level(dscore.score)

    # print results
    Nostrum.Api.create_message!(ctx.msg.channel_id, 
      "#{user_id} is at lv#{level} with #{dscore.score} score.")
  end
end
