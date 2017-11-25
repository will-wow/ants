defmodule Ants.Ants.AntMoveTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ants.Ants.Ant
  alias Ants.Worlds
  alias Ants.Worlds.TileType
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.WorldsMock
  alias Ants.Worlds.WorldMap
  alias Ants.Ants.AntMove

  describe "given an ant at 1, 1" do
    setup [:create_home_ant]

    test "takes the only open path", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 H 0",
        "0 0 0",
      ]

      mock_worlds(world_map)
       
      assert AntMove.move(ant) == %Ant{x: 1, y: 2}
    end
  end

  defp create_home_ant(_context) do
    %{ant: %Ant{x: 1, y: 1}}
  end

  defp mock_worlds(world_map) do
    tile_types =
      world_map
      |> WorldMap.tile_type_of_world_map()
      |> List.to_tuple()

    size = length(world_map)

    WorldsMock
    |> expect(:lookup, fn _, x, y ->
      lookup_tile(tile_types, size, x, y)
    end)
  end 

  defp index_of_coords(size, x, y) do
    (y - size) * size + x
  end

  defp tile_type_at_index(index, tile_types) do
    elem(tile_types, index)
  end

  defp lookup_tile(tile_types, size, x, y) do
    size
    |> index_of_coords(x, y)
    |> tile_type_at_index(tile_types)
    |> TileType.tile_of_type()
  end
end

