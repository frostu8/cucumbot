defmodule Cucumbot.Command do
  @moduledoc """
  Interface for command modules to implement.
  """

  @doc """
  The spec of the command.
  """
  @callback cmdspec() :: map

  @callback guards() :: [Cucumbot.Command.Guard.t]

  @doc """
  Executes the command.
  """
  @callback execute(Nostrum.Struct.Interaction.t) :: no_return

  @spec respond(Nostrum.Struct.Interaction.t, String.t) :: no_return
  def respond(intr, content) do
    Nostrum.Api.create_interaction_response(
      intr,
      %{ type: 4, data: %{ content: content } }
    )
  end

  @spec get_option(map, String.t) :: any | nil
  def get_option(%{options: options}, ident) do
    res = options |> Enum.find(fn option -> 
      option.name === ident 
    end)

    case res do
      nil ->
        nil
      res ->
        res.value
    end
  end

  def get_option(intr, ident) do
    nil
  end

  @spec get_option!(map, String.t) :: any | no_return
  def get_option!(intr, ident) do
    get_option(intr, ident) |> bangify
  end

  def get_member(intr, ident) do
    case get_option(intr, ident) do
      nil ->
        nil
      res ->
        case Integer.parse(res) do
          {res, _rest} ->
            res
          :error ->
            nil
        end
    end
  end

  def get_member!(intr, ident) do
    get_member(intr, ident) |> bangify
  end

  @spec get_subcommand(map, String.t) :: map | nil
  def get_subcommand(%{options: options}, ident) do
    res = options |> Enum.find(fn option -> 
      option.name === ident 
    end)

    case res do
      nil ->
        nil
      res ->
        res
    end
  end

  defp bangify(result) do
    case result do
      nil ->
        raise "attempted to unwrap a nil value"
      res ->
        res
    end
  end

  @doc """
  Executes all guards on a command, returning the first error.
  """
  @spec run_guards(atom, Nostrum.Struct.Interaction.t) :: :ok | String.t
  def run_guards(cmd, intr) do
    case Keyword.fetch(cmd.guards(), :guards) do
      {:ok, guards} ->
        # execute guards
        case Enum.find_value(guards, fn guard -> guard.guard(intr) end) do
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
    guards = Keyword.get(opts, :guards) || []

    quote location: :keep do
      @behaviour Cucumbot.Command

      import Cucumbot.Command, only: [
        get_option: 2, 
        get_option!: 2, 
        get_member: 2,
        get_member!: 2,
        get_subcommand: 2,
        respond: 2
      ]

      @impl true
      def guards do
        unquote(Macro.escape(guards))
      end
    end
  end
end
