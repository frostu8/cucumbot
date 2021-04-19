defmodule Cucumbot.Guards.Admin do
  use Cucumbot.Command.Guard

  def guard(_args, msg) do
    # check if the user has the admin permission or is owner
    guild = Nostrum.Cache.GuildCache.get!(msg.guild_id)

    perms = Nostrum.Struct.Guild.Member.guild_permissions(msg.member, guild)
    if perms |> Enum.any?(fn x -> x === :administrator end) do
      :ok
    else
      ":no_entry_sign: you do not have permission (Administrator) to use this command."
    end
  end
end
