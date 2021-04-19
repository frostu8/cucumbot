defmodule Cucumbot.Cogs.Exp do
  @moduledoc """
  Exp management utilities.
  """

  use Cucumbot.Command, 
    name: "exp",
    guards: [Cucumbot.Guards.Admin]

  alias Cucumbot.Arguments
  alias Cucumbot.Schema.UserScore
  alias Cucumbot.Util
  alias Nostrum.Api

  def execute(args, msg) do
    # get subcommand
    {subcommand, args} = Arguments.next_arg(args)

    case subcommand do
      nil ->
        # no subcommand, print help
        Api.create_message(msg.channel_id,
          "no subcommand provided! valid subcommands: `set`.")
      "set" ->
        subcommand_set(args, msg)
    end
  end

  def subcommand_set(args, msg) do
    case Arguments.next_member(args, msg.guild_id) do
      {nil, _args} ->
        Api.create_message(msg.channel_id, "no user provided!")
      {:error, raw, _args} ->
        Api.create_message(msg.channel_id, 
          content: "failed to find user #{raw}",
          allowed_mentions: :none)
      {member, args} ->
        # try to read the score
        case Arguments.next_int(args) do
          {nil, _args} ->
            Api.create_message(msg.channel_id, "no score provided!")
          {:error, raw, _args} ->
            Api.create_message(msg.channel_id, "\"#{raw}\" is not a valid integer!")
          {score, _args} ->
            dscore = UserScore.get_or_default(member.user.id, msg.guild_id)

            UserScore.update_score(dscore, score)

            Api.create_message(msg.channel_id,
              "member \"#{member.nick || member.user.username}\" " <> 
                  "now has #{score} score")
        end
    end
  end
end
