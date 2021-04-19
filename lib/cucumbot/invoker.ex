defmodule Cucumbot.Invoker do
  @commands [
    Cucumbot.Cogs.About,
    Cucumbot.Cogs.Exp,
    Cucumbot.Cogs.Rank
  ]

  alias Cucumbot.Command

  @spec dispatch_command(Nostrum.Struct.Interaction.t) :: no_return
  def dispatch_command(intr) do
    # handle command
    command = @commands |> Enum.find(
      fn handler -> Map.fetch!(handler.cmdspec(), :name) === intr.data.name end)

    case command do
      nil ->
        # ignore nonexistant command
        :ignore
      handler ->
        # check guards
        case Command.run_guards(command, intr) do
          :ok ->
            # no problemo!
            # execute handler
            handler.execute(intr)
          error ->
            # print error
            Nostrum.Api.create_interaction_response(
              intr, %{ type: 4, data: %{ content: error } }
            )
        end
    end
  end

  def register_commands do
    @commands |> Enum.each(fn command ->
      Nostrum.Api.create_guild_application_command(
        363453410491629568,
        command.cmdspec()
      )
    end)
  end
end
