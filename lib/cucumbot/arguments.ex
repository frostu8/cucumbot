defmodule Cucumbot.Arguments do
  @moduledoc """
  Set of tools for interacting with command arguments.
  """

  import Cucumbot.Util.String

  @type t :: String.t | nil

  @doc """
  Get the next argument of a command.
  """
  @spec next_arg(t) :: {String.t | nil, t}
  def next_arg(nil) do
    # return nil, since there are no more args
    {nil, nil}
  end

  def next_arg(args) do
    # find the next whitespace
    case find_char(args, fn ch -> is_whitespace(ch) end) do
      nil -> 
        # return args in full if there is no following whitespace
        {args, nil}
      end_idx ->
        arg = String.slice(args, 0..end_idx-1)
        rest = String.slice(args, end_idx..-1)

        case find_char(rest, fn ch -> !is_whitespace(ch) end) do
          nil ->
            # return arg, minus the whitespace at the end
            {arg, nil}
          next_idx ->
            # return arg, then the rest
            {arg, String.slice(rest, next_idx..-1)}
        end
    end
  end

  @doc """
  Gets the next argument of a command, and attempts to convert it to an 
  integer.
  """
  @spec next_int(t) :: {integer | nil, t} | {:error, String.t, t}
  def next_int(nil) do
    {nil, nil}
  end

  def next_int(args) do
    # get next arg
    case next_arg(args) do
      {nil, args} -> 
        {nil, args}
      {arg, args} ->
        # try to parse it
        case Integer.parse(arg) do
          {int, _rest} ->
            {int, args}
          :error ->
            {:error, arg, args}
        end
    end
  end

  @doc """
  Gets the next argument of a command, and attempts to resolve it into a
  `Nostrum.Struct.Guild.Member`.
  """
  @spec next_member(t, Nostrum.Snowflake.t) :: {Nostrum.Struct.Guild.Member | nil, t} | {:error, String.t, t}
  def next_member(nil, _ctx) do
    {nil, nil}
  end

  def next_member(args, ctx) do
    case next_arg(args) do
      {nil, args} ->
        {nil, args}
      {mention, args} ->
        # resolve mention
        case Cucumbot.Util.User.resolve_mention(mention) do
          nil ->
            {:error, mention, args}
          user ->
            # get member
            case Cucumbot.Util.User.get_member(ctx, user) do
              {:error, _why} ->
                # could not find user
                {:error, mention, args}
              {:ok, member} ->
                # found user
                {member, args}
            end
        end
    end
  end
end
