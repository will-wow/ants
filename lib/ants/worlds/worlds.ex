defmodule Ants.Worlds do
  alias Ants.Shared.Utils
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.TileSupervisor
  alias Ants.Simulations.SimulationsSupervisor

  @callback create_world(integer, WorldMap.t) :: :ok
  @callback print(integer) :: none 
  @callback lookup(integer, integer, integer) :: Tile.t

  @world_map [
    "0 0 0 0 0 0 0",
    "0 _ _ _ 0 F 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ _ _ 0",
    "0 H _ _ _ _ 0",
    "0 0 0 0 0 0 0"
  ]

  @spec create_world(integer, WorldMap.t) :: :ok
  def create_world(sim, map \\ @world_map) do
    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    @world_map
    |> WorldMap.tile_type_of_world_map()
    |> Utils.map_indexed(fn {type, i} -> 
      x = WorldMap.x_coord_of_index(i, 7)
      y = WorldMap.y_coord_of_index(i, 7)

      {:ok, _} = TileSupervisor.start_tile(sim, type, x, y)
    end)

    :ok
  end

  @spec print(integer) :: none
  def print(sim) do
    Enum.map(6..0, fn y -> 
      Enum.map(0..6, fn x -> 
        tile = lookup(sim, x, y)
        WorldMap.cell_of_tile(tile)
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
    |> IO.puts
  end

  defdelegate surroundings(sim, x, y), to: Surroundings
  defdelegate lookup(sim, x, y), to: TileLookup
end
