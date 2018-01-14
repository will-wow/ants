require IEx

defmodule Ants.Worlds.Surroundings do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.WorldMap
  alias Ants.Simulations.SimId

  @type t :: {
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t(),
          Tile.t()
        }

  @type coords :: {integer, integer}

  @lookup Application.get_env(:ants, :tile_lookup, TileLookup)

  @surroundings_size 3

  @spec surroundings(SimId.t(), integer, integer) :: t
  def surroundings(sim, x, y) do
    Enum.map(-1..1, fn delta_y ->
      Enum.map(-1..1, fn delta_x ->
        coords_of_offset(x, y, delta_x, delta_y)
      end)
    end)
    |> Enum.concat()
    |> Task.async_stream(fn {x, y} ->
      @lookup.lookup(sim, x, y)
    end)
    |> Stream.map(fn {:ok, tile} -> tile end)
    |> Enum.to_list()
    |> List.to_tuple()
  end

  @spec index_of_coords(integer, integer) :: integer
  @spec index_of_coords(integer, integer, integer) :: integer
  def index_of_coords(x, y, size \\ @surroundings_size) do
    y * size + x
  end

  @spec coords_of_index(integer) :: coords
  @spec coords_of_index(integer, integer) :: coords
  def coords_of_index(index, size \\ @surroundings_size) do
    {
      WorldMap.x_coord_of_index(index, size),
      WorldMap.y_coord_of_index(index, size)
    }
  end

  @spec coords_of_offset(integer, integer, integer, integer) :: coords
  defp coords_of_offset(x, y, delta_x, delta_y) do
    {x + delta_x, y + delta_y}
  end
end