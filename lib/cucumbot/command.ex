defmodule Cucumbot.Command do
  @moduledoc """
  Interface for command modules to implement.
  """

  @type cmdspec :: [
    name: String.t,
    guards: [Cucumbot.Command.Guard.t]
  ]

  @doc false
  @callback info() :: cmdspec

  @doc """
  Executes the command.
  """
  @callback execute(Cucumbot.Command.Arguments.t, Nostrum.Struct.Message.t) :: no_return

  @doc """
  Executes all guards, returning the first error.
  """
  @spec guards(atom, Cucumbot.Command.Arguments.t, Nostrum.Struct.Message.t) :: :ok | String.t
  def guards(cmd, args, msg) do
    case Keyword.fetch(cmd.info(), :guards) do
      {:ok, guards} ->
        # execute guards
        case Enum.find_value(guards, fn guard -> guard.guard(args, msg) end) do
          nil ->
            # no problems!
            :ok
          error ->
            # propogate error
            error
        end
      :error ->
        # guards do not exist for this command
        :ok
    end
  end

  defmacro __using__(opts) do
    unless opts |> Keyword.has_key?(:name) do
      raise ArgumentError.exception("No command name specified!")
    end

    quote location: :keep do
      @behaviour Cucumbot.Command

      @impl true
      def info do
        unquote(opts)
      end

      @impl true
      def execute(_args, _msg) do
        :ok
      end

      defoverridable execute: 2
    end
  end
end
