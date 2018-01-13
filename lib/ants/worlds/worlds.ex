defmodule Ants.Worlds do
  alias Ants.Shared.Utils
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.Food
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.TileSupervisor
  alias Ants.Simulations.SimId

  @callback create_world(integer, WorldMap.t()) :: :ok
  @callback print(integer) :: none
  @callback lookup(integer, integer, integer) :: Tile.t()

  @world_map [
    "0 0 0 0 0 0 0 0 0 0 0 0 0",
    "0 _ _ _ _ _ _ _ _ _ _ F 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ F _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 _ _ _ _ _ _ _ F _ _ _ 0",
    "0 _ _ _ _ _ _ _ _ _ _ _ 0",
    "0 H _ _ _ _ _ _ _ _ _ _ 0",
    "0 0 0 0 0 0 0 0 0 0 0 0 0"
  ]

  @map_size Enum.count(@world_map)

  @spec create_world(integer, WorldMap.t()) :: {:ok, home: {integer, integer}}
  def create_world(sim, map \\ @world_map) do
    map
    |> WorldMap.tile_type_of_world_map()
    |> Utils.map_indexed(fn {type, i} ->
         x = WorldMap.x_coord_of_index(i, @map_size)
         y = WorldMap.y_coord_of_index(i, @map_size)

         {:ok, _} = TileSupervisor.start_tile(sim, type, x, y)
       end)

    # TODO: Find Home location
    {:ok, home: {1, 1}}
  end

  @spec print(SimId.t()) :: [String.t()]
  def print(sim) do
    sim
    |> all_tiles()
    |> Enum.map(&WorldMap.cell_of_tile/1)
  end

  @spec all_tiles(SimId.t()) :: [Tile.t()]
  def all_tiles(sim) do
    all_coords()
    |> Task.async_stream(fn {x, y} ->
         sim
         |> lookup(x, y)
       end)
    |> Enum.map(fn {:ok, tile} -> tile end)
  end

  @spec count_food(SimId.t()) :: integer
  def count_food(sim) do
    sim
    |> all_tiles()
    |> Enum.reduce(0, fn tile, acc ->
         case tile do
           %Food{food: food} -> acc + food
           _ -> acc
         end
       end)
  end

  @spec take_food(SimId.t(), integer, integer) :: {:ok, integer} | {:error, :not_food}
  def take_food(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.take_food()
  end

  @spec deposit_food(SimId.t(), integer, integer) :: {:ok, integer} | {:error, :not_home}
  def deposit_food(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.deposit_food()
  end

  @spec deposit_pheromones(SimId.t(), integer, integer) :: {:ok, integer} | {:error, :not_land}
  def deposit_pheromones(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.deposit_pheromones()
  end

  @spec decay_all_pheromones(SimId.t()) :: [Tile.t()]
  def decay_all_pheromones(sim) do
    all_coords()
    |> Task.async_stream(fn {x, y} ->
         decay_pheromones(sim, x, y)
       end)
    |> Enum.map(fn {:ok, tile} -> tile end)
  end

  defdelegate print_tile(tile), to: WorldMap, as: :cell_of_tile

  defdelegate surroundings(sim, x, y), to: Surroundings
  defdelegate lookup(sim, x, y), to: TileLookup
  defdelegate get_tile(sim, x, y), to: TileLookup

  defp decay_pheromones(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.decay_pheromones()
  end

  @spec all_coords :: [{integer, integer}]
  defp all_coords do
    range = 0..(@map_size - 1)

    Enum.map(range, fn y ->
      Enum.map(range, fn x ->
        {x, y}
      end)
    end)
    |> Enum.concat()
  end
end