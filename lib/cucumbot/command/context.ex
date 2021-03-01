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

  @doc """
  Gets the next argument, and attempts to resolve it into a user.

  Returns `nil` if there was no next argument, but instead returns `:error` if
  the user could not be found.
  """
  @spec next_user(t) :: {Nostrum.Struct.User.t | nil, t} | {:error, String.t, t}
  def next_user(ctx) do
    case next_arg(ctx) do
      {nil, ctx} -> 
        {nil, ctx}
      {member_raw, ctx} ->
        # got an argument
        case resolve_mention(member_raw) do
          nil ->
            # this is not a mention or an id
            raise "Unimplemented"
          id ->
            # get user by id
            case Nostrum.Cache.UserCache.get(id) do
              {:ok, user} ->
                {user, ctx}
              {:error, _reason} ->
                {:error, member_raw, ctx}
            end
        end
    end
  end

  @spec resolve_mention(String.t) :: integer | nil
  defp resolve_mention(mention) do
    import String, only: [starts_with?: 2, ends_with?: 2]

    trim = if starts_with?(mention, "<@!") and ends_with?(mention, ">") do
      String.slice(mention, 3..-2)
    else
      mention
    end

    case Integer.parse(trim) do
      :error ->
        nil
      {id, _str} ->
        id
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
