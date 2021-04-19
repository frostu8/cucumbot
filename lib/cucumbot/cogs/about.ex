defmodule Cucumbot.Cogs.About do
  use Cucumbot.Command

  def cmdspec do
    %{ 
      name: "about",
      description: "gets information about the bot"
    }
  end

  def execute(intr) do
    version = Application.spec(:cucumbot, :vsn) |> to_string()

    Nostrum.Api.create_interaction_response(
      intr, 
      %{
        type: 4,
        data: %{
          content: "Running Cucumbot #{version}"
        }
      }
    )
  end
end
