import Config

config :cucumbot, Cucumbot.Repo,
  database: "cucumbot"

config :cucumbot, 
  ecto_repos: [Cucumbot.Repo]

config :nostrum,
  num_shards: :auto

import_config "token.exs"
