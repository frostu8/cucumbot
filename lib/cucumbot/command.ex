defmodule Cucumbot.Command do
  @type opts :: [
    name: String.t
  ]

  @doc false
  @callback opts() :: opts

  @doc """
  Executes the command.
  """
  @callback execute(Cucumbot.Command.Arguments.t, Nostrum.Struct.Message.t) :: no_return

  defmacro __using__(opts) do
    unless opts |> Keyword.has_key?(:name) do
      raise ArgumentError.exception("No command name specified!")
    end

    quote location: :keep do
      @behaviour Cucumbot.Command

      @impl true
      def opts do
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
