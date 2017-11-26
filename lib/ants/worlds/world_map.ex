defmodule Ants.Worlds.WorldMap do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileType
  alias Ants.Worlds.Tile.{Land, Rock, Home, Food}

  @type t :: [String.t]
  @type tile_types :: [TileType.t]
  @typep cell :: String.t
  @typep cell_map :: [cell]

  @cell_of_tile %{
    rock: "0",
    land: "_",
    food: "F",
    home: "H",
    light_pheromone: "p",
    heavy_pheromone: "P"
  }

  @spec tile_type_of_world_map(t) :: tile_types
  def tile_type_of_world_map(world_map) do
    world_map
    |> cell_map_of_world_map()
    |> Enum.reverse()
    |> Enum.concat()
    |> Enum.map(&tile_type_of_cell/1)
  end

  @spec x_coord_of_index(integer, integer) :: integer
  def x_coord_of_index(index, size) do
    Integer.mod(index, size)
  end

  @spec y_coord_of_index(integer, integer) :: integer
  def y_coord_of_index(index, size) do
    Integer.floor_div(index, size)
  end

  @spec cell_of_tile(Tile.t) :: cell
  def cell_of_tile(%Rock{}), do: "0"
  def cell_of_tile(%Land{pheromone: pheromone})
    when pheromone > 0, do: "-"
  def cell_of_tile(%Land{}), do: "_"
  def cell_of_tile(%Food{food: food})
    when food < 5, do: "f"
  def cell_of_tile(%Food{}), do: "F"
  def cell_of_tile(%Home{}), do: "H" 

  @spec cell_map_of_world_map(t) :: cell_map 
  defp cell_map_of_world_map(rows) do
    Enum.map(rows, &split_input_row/1)
  end

  @spec split_input_row(String.t) :: [String.t]
  defp split_input_row(row) do
    String.split(row, " ")
  end

  @spec tile_type_of_cell(cell) :: TileType.t
  defp tile_type_of_cell("0"), do: :rock
  defp tile_type_of_cell("_"), do: :land
  defp tile_type_of_cell("F"), do: :food
  defp tile_type_of_cell("H"), do: :home
  defp tile_type_of_cell("P"), do: :heavy_pheromone
  defp tile_type_of_cell("p"), do: :light_pheromone
end