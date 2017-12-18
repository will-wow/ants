defmodule Ants.Ants.AntMoveTest do
  use ExUnit.Case, async: true

  alias Ants.Ants.Ant
  alias Ants.Worlds.TileType
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.WorldMap
  alias Ants.Ants.AntMove

  describe "an ant at 1, 1 without a path" do
    setup [:create_home_ant]

    test "takes the only open path", %{ant: ant} do
      world_map = [
        "0 _ 0",
        "0 _ 0",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{x: 1, y: 2, path: [{0, 1}]}
    end

    test "goes diagonally", %{ant: ant} do
      world_map = [
        "0 0 _",
        "0 _ 0",
        "0 0 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{x: 2, y: 2, path: [{1, 1}]}
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
                 %Ant{x: 2, y: 1, path: [{1, 0}]},
                 %Ant{x: 1, y: 2, path: [{0, 1}]},
                 %Ant{x: 0, y: 1, path: [{-1, 0}]}
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

  describe "an ant with a path" do
    setup [:create_home_ant, :from_1_0]

    test "goes forward", %{ant: ant} do
      world_map = [
        "_ _ _",
        "_ _ _",
        "_ _ _"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 1, y: 2, path: [{0, 1} | ant.path]}
    end

    test "turns", %{ant: ant} do
      world_map = [
        "0 0 0",
        "0 _ _",
        "0 _ 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 2, y: 1, path: [{1, 0} | ant.path]}
    end

    test "chooses food", %{ant: ant} do
      world_map = [
        "_ _ F",
        "_ _ _",
        "_ _ _"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 2, y: 2, path: [{1, 1} | ant.path]}
    end

    test "goes back when trapped", %{ant: ant} do
      world_map = [
        "0 0 0",
        "0 _ 0",
        "0 _ 0"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 1, y: 0, path: [{0, -1} | ant.path]}
    end
  end

  describe "an ant with food" do
    setup [:create_home_ant, :from_1_0, :with_food]

    test "goes back", %{ant: ant} do
      world_map = [
        "_ _ _",
        "_ _ _",
        "_ _ _"
      ]

      surroundings = make_surroundings(world_map)

      assert AntMove.move(ant, surroundings) == %Ant{ant | x: 1, y: 0, path: []}
    end
  end

  defp create_home_ant(_context) do
    %{ant: %Ant{x: 1, y: 1}}
  end

  defp from_1_0(context) do
    ant = context.ant
    %{context | ant: %Ant{ant | path: [{0, 1}]}}
  end

  def with_food(context) do
    ant = context.ant
    %{context | ant: %Ant{ant | food?: true}}
  end

  @spec make_surroundings(WorldMap.t()) :: Surroundings.t()
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