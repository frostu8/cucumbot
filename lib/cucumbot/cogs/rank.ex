defmodule Cucumbot.Cogs.Rank do
  use Cucumbot.Command

  alias Cucumbot.Schema.UserScore
  alias Cucumbot.Util

  def cmdspec do
    %{ 
      name: "rank",
      description: "gets the rank of a user",
      options: [
        %{
          type: 6, 
          name: "user", 
          description: "the user to check the rank for.",
          required: false
        }
      ]
    }
  end

  def execute(intr) do
    user_id = case get_member(intr.data, "user") do
      nil ->
        intr.member.user.id
      user ->
        user
    end

    # get member
    case Util.User.get_member(intr.guild_id, user_id) do
      {:error, why} ->
        # could not find user
        respond(intr, "failed to find user: #{why}")
      {:ok, member} ->
        # got member
        score = UserScore.get_or_default(user_id, intr.guild_id).score

        respond(
          intr,
          "member \"#{member.nick || member.user.username}\" is " <> 
          "lv#{Cucumbot.Score.score_to_level(score)} " <> 
          "with #{score} score"
        )
    end
  end
end
