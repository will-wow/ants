defmodule Ants.Worlds do

  alias Ants.Worlds.Tile

  @typep world_map :: [[String.t]]
  @typep world :: %{
    optional({integer, integer}) => pid
  }

  ## Consts

  @world_map [
    "0 0 0 0 0 0 0",
    "0 _ _ _ 0 F 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ _ _ 0",
    "0 H _ _ _ _ 0",
    "0 0 0 0 0 0 0"
  ]

  @spec create_world(integer, world_map) :: :ok
  def create_world(sim, map \\ @world_map) do
    world_map = world_map_of_list map
    cell_strings = Enum.concat world_map

    tiles = Enum.map(cell_strings, &tile_of_cell/1)

    :ok
  end

  def print(sim) do
    # TODO
  end

  @spec lookup(integer, integer, integer) :: Tile.t{}
  def lookup(sim, x, y) do
    pid = SimulationRegistry.tile(sim, x, y)
    Tile.get(pid)
    GenServer.call(pid, {:tick, x, y})
  end

  @spec world_map_of_list([String.t]) :: [[String.t]]
  defp world_map_of_list(rows) do
    Enum.map rows, &split_map_rows/1 
  end

  @spec split_map_rows(String.t) :: [String.t]
  defp split_map_rows(row) do
    String.split row, " "
  end

  @spec tile_type_of_cell(string) :: atom
  defp tile_type_of_cell("0"), do: :rock
  defp tile_type_of_cell("_"), do: :land
  defp tile_type_of_cell("F"), do: :food
  defp tile_type_of_cell("H"), do: :home

  @spec tile_of_cell(string) :: pid
  defp tile_of_cell(cell) do
    type = tile_type_of_cell(cell)
    Tile.start_link(type, [])
  end
end
