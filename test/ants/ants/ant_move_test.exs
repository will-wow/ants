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
        "0 _ 0",
        "0 0 0",
      ]

      surroundings = make_surroundings(world_map)
       
      assert AntMove.move(ant, surroundings) == %Ant{x: 1, y: 2}
    end

    test "goes diagonally", %{ant: ant} do
      world_map = [
        "0 0 _",
        "0 _ 0",
        "0 0 0",
      ]

      surroundings = make_surroundings(world_map)
       
      assert AntMove.move(ant, surroundings) == %Ant{x: 2, y: 2}
    end


    test "picks land over home", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 _ 0",
        "0 H 0",
      ]

      surroundings = make_surroundings(world_map)
       
      assert AntMove.move(ant, surroundings) == %Ant{x: 1, y: 2}
    end

    test "doesn't go back", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 _ 0",
        "0 _ 0",
      ]

      surroundings = make_surroundings(world_map)

      ant = %Ant{ant | path: [{0, -1}]}
       
      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 1, y: 2}
    end

    test "chooses a land", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 _ p",
        "0 0 0",
      ]

      surroundings = make_surroundings(world_map)

      assert Enum.member?(
        [%Ant{x: 2, y: 1}, %Ant{x: 1, y: 2}],
        AntMove.move(ant, surroundings)
      )
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

