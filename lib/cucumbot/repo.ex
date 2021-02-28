defmodule Cucumbot.Repo do
  use Ecto.Repo,
    otp_app: :cucumbot,
    adapter: Ecto.Adapters.MyXQL
end
