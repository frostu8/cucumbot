defmodule Cucumbot.Util.Snowflake do
  import Nostrum.Snowflake, only: [is_snowflake: 1]

  def creation_time_unix(snowflake) when is_snowflake(snowflake) do
    use Bitwise

    (snowflake >>> 22) + Nostrum.Constants.discord_epoch()
  end
end
