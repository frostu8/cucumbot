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
end
