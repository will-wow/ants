defmodule Ants.Worlds.SurroundingsTest do
  use ExUnit.Case, async: false
  import Mox

  alias Ants.Worlds.Tile.{Land, Home, Rock}
  alias Ants.Worlds.TileType
  alias Ants.Worlds.TileLookupMock
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Point
  alias Ants.Worlds.Surroundings

  describe "surroundings" do
    # Global mode so the async tasks can do a lookup
    setup :set_mox_global

    test "finds the surroundings in a world" do
      world_map = [
        "0 0 0 0 0",
        "0 0 _ _ 0",
        "0 _ H 0 0",
        "0 _ 0 _ 0",
        "0 0 0 0 0"
      ]

      mock_tile_lookup(world_map)

      assert Surroundings.surroundings(1, 2, 2) ==
               [
                 %Land{},
                 %Rock{},
                 %Land{},
                 %Land{},
                 %Home{},
                 %Rock{},
                 %Rock{},
                 %Land{},
                 %Land{}
               ]
    end
  end

  defp mock_tile_lookup(world_map) do
    tile_types =
      world_map
      |> WorldMap.to_tile_type_list()
      |> Enum.map(fn type ->
        {:ok, tile} = TileType.tile_of_type(type)
        tile
      end)
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
    Point.to_index({x, y}, size)
    |> tile_at_index(tiles)
  end
end
