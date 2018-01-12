defmodule Ants.Ants.Move do
  alias Ants.Shared.Knobs
  alias Ants.Worlds.Surroundings

  @type coord :: integer
  @type t :: {coord, coord}

  @highest_index Knobs.constant(:map_size) - 1

  def x({x, _}), do: x
  def y({_, y}), do: y

  @spec forward_to_index(t) :: Enum.index()
  def forward_to_index({x, y}) do
    Surroundings.index_of_coords(x + 1, y + 1)
  end

  @spec backward_to_index(t) :: Enum.index()
  def backward_to_index(move) do
    @highest_index - forward_to_index(move)
  end
end