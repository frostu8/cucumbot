defmodule Cucumbot.Cogs.Rank do
  use Cucumbot.Command, name: "rank"

  alias Cucumbot.Arguments
  alias Cucumbot.Schema.UserScore
  alias Cucumbot.Util

  alias Nostrum.Api

  def execute(args, msg) do
    {user_mention, _args} = Arguments.next_arg(args)

    user_id = case user_mention do
      nil ->
        msg.author.id
      user_mention ->
        Util.User.resolve_mention(user_mention)
    end

    case user_id do
      nil ->
        # could not resolve mention
        Api.create_message(msg.channel_id,
          content: "could not find user #{user_mention}",
          allowed_mentions: :none)
      user_id ->
        # get member
        case Util.User.get_member(msg.guild_id, user_id) do
          {:error, why} ->
            # could not find user
            Api.create_message(msg.channel_id,
              content: "could not find user #{user_mention}",
              allowed_mentions: :none)
          {:ok, member} ->
            # got member
            score = UserScore.get_or_default(user_id, msg.guild_id).score

            Api.create_message(msg.channel_id,
              "member \"#{member.nick || member.user.username}\" is " <> 
                "lv#{Cucumbot.Score.score_to_level(score)} " <> 
                  "with #{score} score")
        end
    end
  end
end
