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

    assert TileSelector.select_tile(locations) == 4
  end
end