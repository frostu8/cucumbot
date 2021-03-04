defmodule Cucumbot.Util.User do
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
end
