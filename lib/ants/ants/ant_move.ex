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
    |> Enum.max_by(fn {rating, i} -> rating end)
    |> get_index()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec rate_tile(Tile.t) :: integer
  def rate_tile(%Food{}), do: 5
  def rate_tile(%Land{}), do: random_rating(3)
  def rate_tile(%Home{}), do: 1
  def rate_tile(%Rock{}), do: 0

  @spec randon_rating(integer) :: float
  defp random_rating(rating) do
    rating + random_decimal()
  end

  @spec random_decimal() :: float
  defp random_decimal() do
    Enum.random(-100..100) / 100
  end

  defp get_index(tuple), do: elem(tuple, 1)

  defp update_ant_coords({surrounding_x, surrounding_y}, ant = %Ant{x: x, y: y}) do
    %Ant{ant | x: x + surrounding_x - 1,
               y: y + surrounding_y - 1 }
  end
end