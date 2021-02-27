defmodule Cucumbot.Command.Context do
  defstruct [:cmd, :args, :msg]

  import Cucumbot.Util.String

  @type t :: %__MODULE__{
    cmd: String.t,
    args: String.t,
    msg: Nostrum.Struct.Message
  }

  @doc """
  A fully featured function that parses a raw command, using a prefix, and
  returns the result, or nil, if it didn't have a prefix.
  """
  @spec parse(String.t, Nostrum.Struct.Message.t) :: t | nil
  def parse(msg, prefix) do
    if String.starts_with?(msg.content, prefix) do
      command = String.slice(msg.content, String.length(prefix)..-1)

      %__MODULE__{new(command) | msg: msg}
    else
      nil
    end
  end

  @doc """
  Slices a raw argument list into a command.
  """
  @spec new(String.t) :: t
  def new(msg) do
    # get command
    {cmd, args} = next_arg_raw(msg)

    %__MODULE__{cmd: cmd, args: args}
  end

  @doc """
  Get the next argument of a command.
  """
  @spec next_arg(t) :: {String.t | nil, t}
  def next_arg(context) do
    case Map.get(context, :args) do
      nil ->
        # return nil, since there are no more args
        {nil, context}
      args ->
        # get next argument
        {arg, rest} = next_arg_raw(args)

        {arg, %__MODULE__{context | args: rest}}
    end
  end

  @spec next_arg_raw(String.t) :: {String.t, String.t | nil}
  defp next_arg_raw(args) do
    # find the next whitespace
    case find_char(args, fn ch -> is_whitespace(ch) end) do
      nil -> 
        # return args in full
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
