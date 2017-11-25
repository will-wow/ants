defmodule Ants.Ants.AntMoveTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ants.Ants.Ant
  alias Ants.Worlds
  alias Ants.Worlds.TileType
  alias Ants.Worlds.Surroundings
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

      surroundings = make_surroundings(world_map)
       
      assert AntMove.move(ant, surroundings) == %Ant{x: 1, y: 2}
    end
  end

  defp create_home_ant(_context) do
    %{ant: %Ant{x: 1, y: 1}}
  end

  @spec make_surroundings(WorldMap.t) :: Surroundings.t
  defp make_surroundings(world_map) do
    world_map
    |> WorldMap.tile_type_of_world_map()
    |> Enum.map(fn type -> 
      {:ok, tile} = TileType.tile_of_type(type) 
      tile
    end)
    |> List.to_tuple()
  end
end

