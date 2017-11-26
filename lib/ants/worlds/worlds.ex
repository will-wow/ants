defmodule Ants.Worlds do
  alias Ants.Shared.Utils
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.TileSupervisor
  alias Ants.Simulations.SimId

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
    @world_map
    |> WorldMap.tile_type_of_world_map()
    |> Utils.map_indexed(fn {type, i} -> 
      x = WorldMap.x_coord_of_index(i, 7)
      y = WorldMap.y_coord_of_index(i, 7)

      {:ok, _} = TileSupervisor.start_tile(sim, type, x, y)
    end)

    :ok
  end

  @spec print(integer) :: :ok
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

  @spec take_food(SimId.t, integer, integer) :: {:ok, integer}
  def take_food(sim, x, y) do
    sim
    |> lookup(x, y)
    |> Tile.take_food()
  end

  @spec deposit_food(SimId.t, integer, integer) :: {:ok, integer} | {:error, :not_food}
  def deposit_food(sim, x, y) do
    sim
    |> lookup(x, y)
    |> Tile.deposit_food()
  end

  @spec deposit_pheromones(SimId.t, integer, integer) :: {:ok, integer} | {:error, :not_land}
  def deposit_pheromones(sim, x, y) do
    sim
    |> lookup(x, y)
    |> Tile.deposit_pheromones()
  end

  @spec decay_all_pheromones(SimId.t) :: [Tile.t]
  def decay_all_pheromones(sim) do
    all_coords()
    |> Task.async_stream(fn {x, y} ->
      decay_pheromones(sim, x, y)
    end)
    |> Enum.map(fn {:ok, tile} -> tile end)
  end

  defp decay_pheromones(sim, x, y) do
    sim
    |> lookup(x, y)
    |> Tile.decay_pheromones()
  end

  @spec all_coords :: [{integer, integer}]
  defp all_coords do
    Enum.map(6..0, fn y -> 
      Enum.map(0..6, fn x -> 
        {x, y}
      end)
    end)
    |> Enum.concat
  end
end
