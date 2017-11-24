defmodule Ants.Worlds do

  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.Land
  alias Ants.Worlds.Tile.Rock
  alias Ants.Worlds.Tile.Home
  alias Ants.Worlds.Tile.Food
  alias Ants.Worlds.TileSupervisor
  alias Ants.Registries.SimRegistry
  alias Ants.Simulations.SimulationsSupervisor

  @typep world_map :: [[String.t]]
  @typep world :: %{
    optional({integer, integer}) => pid
  }

  ## Consts
  @cell_of_tile%{
    rock: "0",
    land: "_",
    food: "F",
    home: "H",
  }

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
    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    world_map = world_map_of_list map
    cell_strings = Enum.concat world_map

    tiles = Enum.map(cell_strings, &tile_type_of_cell/1)

    tiles
    |> Stream.with_index
    |> Enum.each(fn {type, i} -> 
      x = Integer.mod(i, 7)
      y = Integer.floor_div(i, 7)

      TileSupervisor.start_tile(sim, type, x, y)
    end)

    :ok
  end

  def print(sim) do
    Enum.map(6..0, fn y -> 
      Enum.map(0..6, fn x -> 
        tile = lookup(sim, x, y)
        cell_of_tile(tile)
      end)
    end)
  end

  @spec lookup(integer, integer, integer) :: Tile.t{}
  def lookup(sim, x, y) do
    pid = TileSupervisor.get_tile(sim, x, y)
    Tile.get(pid)
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

  @spec cell_of_tile(Tile.t) :: string
  defp cell_of_tile(%Rock{}), do: "0"
  defp cell_of_tile(%Land{pheromone: pheromone})
    when pheromone > 0, do: "p"
  defp cell_of_tile(%Land{}), do: "_"
  defp cell_of_tile(%Food{}), do: "F"
  defp cell_of_tile(%Home{}), do: "H" 
end
