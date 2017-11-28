defmodule Ants.Ants.Move do
  alias Ants.Worlds.Surroundings

  @type t :: {integer, integer}

  def x({x, _}), do: x
  def y({_, y}), do: y

  @spec to_index(t) :: Enum.index()
  def to_index({x, y}) do
    Surroundings.index_of_coords(x + 1, y + 1)
  end
end
