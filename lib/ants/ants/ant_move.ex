defmodule Ants.Ants.AntMove do
  alias Ants.Shared.Utils
  alias Ants.Ants.Ant
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile.{Food, Land, Home, Rock}

  @spec move(%Ant{}, Surroundings.t) :: %Ant{}
  def move(
    ant = %Ant{x: x, y: y, food?: food?, path: path},
    surroundings
  ) do
    surroundings
    |> Tuple.to_list()
    |> Utils.map_indexed(fn {tile, i} -> 
      {rate_tile(tile), i}
    end)
    |> IO.inspect
    |> Enum.max_by(fn {rating, i} -> rating end)
    |> get_index()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec rate_tile(Tile.t) :: integer
  def rate_tile(%Food{}), do: 3
  def rate_tile(%Land{}), do: 2
  def rate_tile(%Home{}), do: 1
  def rate_tile(%Rock{}), do: 0

  defp get_index(tuple), do: elem(tuple, 1)

  defp update_ant_coords({delta_x, delta_y}, ant = %Ant{x: x, y: y}) do
    %Ant{ant | x: x + delta_x, y: y + delta_y }
  end
end