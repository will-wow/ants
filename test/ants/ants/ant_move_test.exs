defmodule Ants.Ants.AntMoveTest do
  use ExUnit.Case, async: true

  alias Ants.Ants.Ant
  alias Ants.Worlds.TileType
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.WorldMap
  alias Ants.Ants.AntMove

  describe "an ant at 1, 1" do
    setup [:create_home_ant]

    test "takes the only open path", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 _ 0",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{x: 1, y: 2}
    end

    test "goes diagonally", %{ant: ant} do
      world_map = [
        "0 0 _",
        "0 _ 0",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{x: 2, y: 2}
    end

    test "chooses a land or home", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "H _ p",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert Enum.member?(
               [
                 %Ant{x: 2, y: 1},
                 %Ant{x: 1, y: 2},
                 %Ant{x: 0, y: 1}
               ],
               AntMove.move(ant, surroundings)
             )
    end

    test "raises when trapped", %{ant: ant} do
      world_map = [
        "0 0 0",
        "0 _ 0",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert_raise(RuntimeError, fn -> AntMove.move(ant, surroundings) end)
    end
  end

  describe "an ant with food" do
    setup [:create_home_ant, :with_food]

    test "goes toward home", %{ant: ant} do
      world_map = [
        "_ _ _",
        "_ _ _",
        "H _ _"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 0, y: 0}
    end
  end

  defp create_home_ant(_context) do
    %{ant: %Ant{x: 1, y: 1}}
  end

  def with_food(context) do
    ant = context.ant
    %{context | ant: %Ant{ant | food?: true}}
  end

  @spec make_surroundings(WorldMap.t()) :: Surroundings.t()
  defp make_surroundings(world_map) do
    world_map
    |> WorldMap.to_tile_type_list()
    |> Enum.map(fn type ->
      {:ok, tile} = TileType.tile_of_type(type)
      tile
    end)
  end
end
