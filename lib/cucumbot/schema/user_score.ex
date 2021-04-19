defmodule Cucumbot.Schema.UserScore do
  use Ecto.Schema

  @primary_key false

  schema "scores" do
    field :user_id,  :integer, primary_key: true
    field :guild_id, :integer, primary_key: true
    field :score,    :integer
    field :cooldown, :integer
  end

  @type t :: %__MODULE__{
    user_id: integer,
    guild_id: integer,
    score: non_neg_integer,
    cooldown: integer
  }

  alias Cucumbot.Repo

  def changeset(score, params \\ %{}) do
    score
    |> Ecto.Changeset.cast(params, [:user_id, :guild_id, :score, :cooldown])
    |> Ecto.Changeset.validate_required([:user_id, :guild_id, :score, :cooldown])
    |> Ecto.Changeset.validate_number(:score, greater_than_or_equal_to: 0)
  end

  @doc """
  Gets a user from the score repo.
  """
  @spec get(integer, integer) :: t | nil
  def get(user_id, guild_id) do
    Repo.get_by(__MODULE__, [user_id: user_id, guild_id: guild_id])
  end

  @doc """
  Same as `get`, but returns a default score struct if not found.
  """
  @spec get_or_default(integer, integer) :: t
  def get_or_default(user_id, guild_id) do
    case get(user_id, guild_id) do
      nil ->
        %__MODULE__{default() | user_id: user_id, guild_id: guild_id}
      result ->
        result
    end
  end

  @doc """
  Updates a score.
  """
  @spec update(t, non_neg_integer, integer) :: no_return
  def update(user, score, cooldown) do
    Repo.insert(
      changeset(user, %{score: score, cooldown: cooldown}), 
      on_conflict: :replace_all,
      conflict_target: [:score, :cooldown])
  end

  @doc """
  Updates a score only.
  """
  @spec update_score(t, non_neg_integer) :: no_return
  def update_score(user, score) do
    Repo.insert(
      changeset(user, %{score: score}), 
      on_conflict: :replace_all,
      conflict_target: :score)
  end

  defp default do
    %__MODULE__{score: 0, cooldown: 0}
  end
end
