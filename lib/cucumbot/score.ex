defmodule Cucumbot.Score do
  alias Cucumbot.Schema.UserScore
  alias Cucumbot.Util.Snowflake

  @spec handle_message(Nostrum.Struct.Message.t) :: no_return
  def handle_message(msg) do
    # get user's exp
    dscore = UserScore.get_or_default(msg.author.id, msg.guild_id)

    timestamp = Snowflake.creation_time_unix(msg.id);

    # compare timestamp
    if dscore.cooldown < timestamp do
      # give exp
      UserScore.update(dscore, 
        dscore.score + rng_score(), 
        make_cooldown(timestamp))
    end
  end

  @doc """
  Calculates a slighty random difference for obtaining score.
  """
  @spec rng_score() :: integer
  def rng_score() do
    trunc(:rand.uniform() * 3) + 4
  end

  @doc """
  Transforms a score into a level.
  """
  @spec score_to_level(integer) :: integer
  def score_to_level(score) do
    floor((:math.sqrt(score + 100) - 10) / 5)
  end

  @doc """
  Transforms a level into a score.
  """
  @spec level_to_score(integer) :: integer
  def level_to_score(level) do
    25*level*level + 100*level
  end

  @doc """
  Makes a cooldown relative to a given UNIX timestamp.
  """
  @spec make_cooldown(integer) :: integer
  def make_cooldown(timestamp) do
    # cooldown is 20 seconds
    timestamp + 20 * 1000
  end
end
