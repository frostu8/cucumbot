defmodule Cucumbot.Cogs.Exp do
  @moduledoc """
  Exp management utilities.
  """

  use Cucumbot.Command, guards: [Cucumbot.Guards.Admin]

  alias Cucumbot.Schema.UserScore
  alias Cucumbot.Util

  def cmdspec do
    %{ 
      name: "exp",
      description: "exp management utilities",
      options: [
        %{
          type: 1,
          name: "set",
          description: "sets the exp of a user",
          options: [
            %{
              type: 6,
              name: "user",
              description: "the user to modify",
              required: true
            },
            %{
              type: 4,
              name: "score",
              description: "the score to set",
              required: true
            }
          ]
        }
      ]
    }
  end

  def execute(intr) do
    # get subcommand
    case get_subcommand(intr.data, "set") do
      nil ->
        # no subcommand, print help
        respond(
          intr,
          "no subcommand provided! valid subcommands: `set`."
        )
      subcmd ->
        subcommand_set(intr, subcmd)
    end
  end

  def subcommand_set(intr, subcmd) do
    case Util.User.get_member(intr.guild_id, get_member!(subcmd, "user")) do
      {:error, why} ->
        # could not find user
        respond(intr, "failed to find user: #{why}")
      {:ok, member} ->
        # got member
        score = get_option!(subcmd, "score")
        
        dscore = UserScore.get_or_default(member.user.id, intr.guild_id)

        UserScore.update_score(dscore, score)

        respond(
          intr,
          "member \"#{member.nick || member.user.username}\" " <> 
          "now has #{score} score"
        )
    end
  end
end
