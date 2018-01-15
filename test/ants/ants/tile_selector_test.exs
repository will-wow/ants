defmodule Ants.Ants.TileSelectorTest do
  use ExUnit.Case, async: true

  alias Ants.Worlds.Tile.{Food, Land, Rock}
  alias Ants.Ants.TileSelector

  test "chooses food" do
    locations = [
      {%Land{pheromone: 10}, 2},
      {%Food{food: 10}, 4},
      {%Land{pheromone: 0}, 5},
      {%Rock{}, 6}
    ]

    assert TileSelector.select(locations, :food) == {:ok, 4}
  end

  test "error when empty" do
    locations = []

    assert TileSelector.select(locations, :land) == {:error, :blocked}
  end
end
