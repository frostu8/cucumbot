defmodule Cucumbot.Util.User do
  alias Nostrum.Cache.GuildCache

  alias Nostrum.Struct.Guild
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.User

  alias Nostrum.Api

  @doc """
  Attempts to resolve a mention into a user ID.
  """
  @spec resolve_mention(String.t) :: integer | nil
  def resolve_mention(mention) do
    import String, only: [starts_with?: 2, ends_with?: 2]

    trim = if starts_with?(mention, "<@!") and ends_with?(mention, ">") do
      String.slice(mention, 3..-2)
    else
      mention
    end

    case Integer.parse(trim) do
      :error ->
        nil
      {id, _str} ->
        id
    end
  end

  @doc """
  Attempts to get a fully qualified guild member from the API and the cache.
  """
  @spec get_member(Guild.id, User.id) :: {:ok, Member.t} | {:error, String.t}
  def get_member(guild_id, user_id) do
    case GuildCache.get(guild_id) do
      {:ok, guild} ->
        case Map.get(guild.members, user_id) do
          nil ->
            get_member_api(guild_id, user_id)
          member ->
            {:ok, member}
        end
      {:error, _reason} ->
        get_member_api(guild_id, user_id)
    end
  end

  defp get_member_api(guild_id, user_id) do
    case Api.get_guild_member(guild_id, user_id) do
      {:ok, member} ->
        {:ok, member}
      {:error, _why} ->
        {:error, "guild is not in cache, and no member with ID" <>
          "#{user_id} could be found"}
    end
  end
end
