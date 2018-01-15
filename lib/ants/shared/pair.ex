defmodule Ants.Shared.Pair do
  @type t(first, second) :: {first, second}

  @spec first(t(any, any)) :: any
  def first(pair) do
    elem(pair, 0)
  end

  @spec last(t(any, any)) :: any
  def last(pair) do
    elem(pair, 1)
  end
end
