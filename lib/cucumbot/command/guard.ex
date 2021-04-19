defmodule Cucumbot.Command.Guard do
  @moduledoc """
  Guards are naive conditionals for commands that want to be restricted to a
  certain context.
  """

  @type t :: atom

  @doc """
  Executes the guard, returning `nil` if the command should execute, or a
  string denoting the reason why it cannot.
  """
  @callback guard(Nostrum.Struct.Interaction.t) :: nil | String.t

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour Cucumbot.Command.Guard

      @impl true
      def guard(msg) do
        nil
      end

      defoverridable guard: 1
    end
  end
end
