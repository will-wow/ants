defmodule Ants.Ants.Move do
  alias Ants.Worlds.Surroundings

  @type coord :: integer
  @type t :: {coord, coord}

  @row_length 3
  @highest_index @row_length * 3 - 1

  def x({x, _}), do: x
  def y({_, y}), do: y

  @spec forward_to_index(t) :: Enum.index()
  def forward_to_index({x, y}) do
    Surroundings.index_of_coords(x + 1, y + 1, @row_length)
  end

  @spec backward_to_index(t) :: Enum.index()
  def backward_to_index(move) do
    @highest_index - forward_to_index(move)
  end
end
