defmodule Ants.Worlds.SurroundingsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Land}
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.TileType
  alias Ants.Worlds.TileLookupMock
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Surroundings

  test "finds the surroundings in a world" do
    world_map = [
      "0 0 0 0 0",
      "0 _ _ _ 0",
      "0 _ H _ 0",
      "0 _ _ _ 0",
      "0 0 0 0 0"
    ]

    mock_tile_lookup(world_map)
      
    assert Surroundings.surroundings(1, 2, 2) == [
      %Land{}, %Land{}, %Land{},
      %Land{}, %Land{}, %Land{},
      %Land{}, %Land{}, %Land{}
    ]
  end

  defp mock_tile_lookup(world_map) do
    tile_types =
      world_map
      |> WorldMap.tile_type_of_world_map()
      |> Enum.map(&TileType.tile_of_type/1)
      |> List.to_tuple()

    size = length(world_map)

    TileLookupMock
    |> stub(:lookup, fn _, x, y ->
      lookup_tile(tile_types, size, x, y)
    end)
  end 

  defp tile_at_index(index, tile_types) do
    elem(tile_types, index)
  end

  defp lookup_tile(tiles, size, x, y) do
    Surroundings.index_of_coords(x, y, size)
    |> tile_at_index(tiles)
  end
end


