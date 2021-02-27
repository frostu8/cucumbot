defmodule Cucumbot.Util.String do
  @type char_fn :: (non_neg_integer -> boolean)

  @spec find_char(String.t, char_fn) :: non_neg_integer | nil
  def find_char(str, test), do: find_char(str, 0, test)

  @spec find_char(String.t, non_neg_integer, char_fn) :: non_neg_integer | nil
  def find_char("", _idx, _test) do
    nil
  end

  def find_char(str, idx, test) do
    <<char::utf8, rest::binary>> = str

    if test.(char) do
      # return index
      idx
    else
      # only continue looking for char if the string has another character
      if String.length(rest) > 0 do
        find_char(rest, idx + 1, test)
      else
        nil
      end
    end
  end

  @spec is_whitespace(non_neg_integer) :: boolean
  def is_whitespace(char) do
    char === 0x20
  end
end
