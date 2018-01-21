defmodule Ants.Worlds.TileTypeTest do
  use ExUnit.Case, async: true

  alias Ants.Shared.Knobs
  alias Ants.Worlds.Tile.{Land, Food, Rock, Home}
  alias Ants.Worlds.TileType

  @starting_food Knobs.constant(:starting_food)

  describe "given a tile type" do
    test "returns a land" do
      assert TileType.tile_of_type(:land) == {:ok, %Land{}}
    end

    test "returns a rock" do
      assert TileType.tile_of_type(:rock) == {:ok, %Rock{}}
    end

    test "returns a home" do
      assert TileType.tile_of_type(:home) == {:ok, %Home{}}
    end

    test "returns a food" do
      assert TileType.tile_of_type(:food) == {:ok, %Food{food: @starting_food}}
    end

    test "returns a light_pheromone" do
      assert TileType.tile_of_type(:light_pheromone) == {:ok, %Land{pheromone: 5}}
    end

    test "returns a heavy_pheromone" do
      assert TileType.tile_of_type(:heavy_pheromone) == {:ok, %Land{pheromone: 10}}
    end
  end
end
