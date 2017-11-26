defmodule Ants.Ants.TileSelectorTest do
  use ExUnit.Case, async: true
  import Mox


  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Food, Land, Home, Rock}
  alias Ants.Ants.AntMove
  alias Ants.Ants.TileSelector

  test "chooses food" do
    locations = [
      {%Land{pheromone: 10}, 2},
      {%Food{food: 10}, 4},
    ]
      
    assert TileSelector.select_tile(locations) == 4
  end
end


