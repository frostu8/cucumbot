defmodule Cucumbot.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores, primary_key: false) do
      add :user_id,  :bigint, primary_key: true
      add :guild_id, :bigint, primary_key: true
      add :score,    :integer
      add :cooldown, :bigint
    end
  end
end
