defmodule Ants.Worlds.Surroundings do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.WorldMap

  @type t :: {
    Tile.t, Tile.t, Tile.t,
    Tile.t, Tile.t, Tile.t,
    Tile.t, Tile.t, Tile.t,
  }

  @lookup Application.get_env(:ants, :tile_lookup, TileLookup)

  @surroundings_size 3

  @spec surroundings(integer, integer, integer) :: t
  def surroundings(sim, x, y) do
    Enum.map(-1..1, fn delta_y -> 
      Enum.map(-1..1, fn delta_x -> 
        coords_of_offset(x, y, delta_x, delta_y)
      end)
    end)
    |> Enum.concat
    |> Enum.map(fn {x, y} -> 
      Task.async(fn -> @lookup.lookup(sim, x, y) end)
    end)
    |> Enum.map(&Task.await/1)
  end

  @spec index_of_coords(integer, integer) :: integer
  @spec index_of_coords(integer, integer, integer) :: integer
  def index_of_coords(x, y, size \\ @surroundings_size) do
    (y - size) * size + x
  end

  @spec coords_of_index(integer) :: {integer, integer}
  @spec coords_of_index(integer, integer) :: {integer, integer}
  def coords_of_index(index, size \\ @surroundings_size) do
    {
      WorldMap.x_coord_of_index(index, size),
      WorldMap.y_coord_of_index(index, size)
    }
  end

  @spec coords_of_offset(integer, integer, integer, integer) :: {integer, integer}
  defp coords_of_offset(x, y, delta_x, delta_y) do
    {x + delta_x, y + delta_y}
  end
end