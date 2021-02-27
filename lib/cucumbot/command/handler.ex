defmodule Cucumbot.Command.Handler do
  @doc """
  Returns the name of the command, used to resolve a command.
  """
  @callback name() :: String.t

  @doc """
  Executes the command.
  """
  @callback execute(Cucumbot.Command.Context.t) :: no_return

  defmacro __using__(opts) do
    name = case opts |> Keyword.get(:name) do
      nil ->
        raise ArgumentError.exception("No command name specified!")
      name ->
        name
    end

    quote location: :keep do
      @behaviour Cucumbot.Command.Handler

      @impl true
      def name do
        unquote name
      end

      @impl true
      def execute(_ctx) do
        :ok
      end

      defoverridable execute: 1, name: 0
    end
  end
end
