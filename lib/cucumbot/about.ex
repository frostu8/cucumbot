defmodule Cucumbot.About do
  use Cucumbot.Command.Handler, name: "about"

  def execute(ctx) do
    version = Application.spec(:cucumbot, :vsn) |> to_string()

    Nostrum.Api.create_message(ctx.msg.channel_id, "Running Cucumbot #{version}")
  end
end
