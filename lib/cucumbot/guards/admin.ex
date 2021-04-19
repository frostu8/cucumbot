defmodule Cucumbot.Guards.Admin do
  use Cucumbot.Command.Guard

  def guard(intr) do
    # check if the user has the admin permission or is owner
    guild = Nostrum.Cache.GuildCache.get!(intr.guild_id)

    perms = Nostrum.Struct.Guild.Member.guild_permissions(intr.member, guild)
    if perms |> Enum.any?(fn x -> x === :administrator end) do
      :ok
    else
      ":no_entry_sign: you do not have permission (Administrator) to use this command."
    end
  end
end
