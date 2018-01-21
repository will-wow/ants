defmodule Ants.Worlds.WorldMap do
  alias Ants.Worlds.TileType

  @type t :: [input_row]
  @type tile_types :: [TileType.t()]
  @typep input_row :: String.t()
  @typep cell :: String.t()

  @spec to_tile_type_list(t) :: tile_types
  def to_tile_type_list(world_map) do
    world_map
    |> to_cell_list()
    |> Enum.map(&tile_type_of_cell/1)
  end

  @spec to_cell_list(t) :: [cell]
  defp to_cell_list(rows) do
    rows
    |> Enum.map(&split_input_row/1)
    |> Enum.reverse()
    |> Enum.concat()
  end

  @spec split_input_row(input_row) :: [cell]
  defp split_input_row(row) do
    String.split(row, " ")
  end

  @spec tile_type_of_cell(cell) :: TileType.t()
  defp tile_type_of_cell("0"), do: :rock
  defp tile_type_of_cell("_"), do: :land
  defp tile_type_of_cell("F"), do: :food
  defp tile_type_of_cell("H"), do: :home
  defp tile_type_of_cell("P"), do: :heavy_pheromone
  defp tile_type_of_cell("p"), do: :light_pheromone
end
