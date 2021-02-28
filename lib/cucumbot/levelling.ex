defmodule Cucumbot.Levelling do
  use Nostrum.Consumer

  alias Cucumbot.Levelling.Store

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    alias Cucumbot.Util.Snowflake

    # do not handle exp for bots
    unless msg.author.bot do
      # only handle exp for guilds
      if msg.guild_id do
        # get user's exp
        dscore = Store.get_or_default(msg.author.id, msg.guild_id)

        timestamp = Snowflake.creation_time_unix(msg.id);

        # compare timestamp
        if dscore.cooldown < timestamp do
          # give exp
          Store.update(dscore, 
            dscore.score + rng_score(), 
            make_cooldown(timestamp))
        end
      end
    end
  end

  def handle_event(_event) do
    :noop
  end

  # LEVELLING LOGIC
  
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

  @spec make_cooldown(integer) :: integer
  def make_cooldown(timestamp) do
    # cooldown is 20 seconds
    timestamp + 20 * 1000
  end
end
