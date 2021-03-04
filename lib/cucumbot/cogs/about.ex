defmodule Cucumbot.Cogs.About do
  use Cucumbot.Command, name: "about"

  def execute(_args, msg) do
    version = Application.spec(:cucumbot, :vsn) |> to_string()

    Nostrum.Api.create_message(msg.channel_id, "Running Cucumbot #{version}")
  end
end
