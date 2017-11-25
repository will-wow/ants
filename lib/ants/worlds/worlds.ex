defmodule Ants.Worlds do
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Tile
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
    |> Stream.with_index()
    |> Enum.each(fn {type, i} -> 
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


  @spec lookup(integer, integer, integer) :: Tile.t
  def lookup(sim, x, y) do
    pid = TileSupervisor.get_tile(sim, x, y)
    Tile.get(pid)
  end
end
