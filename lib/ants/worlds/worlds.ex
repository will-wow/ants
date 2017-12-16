defmodule Ants.Worlds do
  alias Ants.Shared.Utils
  alias Ants.Worlds.WorldMap
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.TileSupervisor
  alias Ants.Simulations.SimId

  @callback create_world(integer, WorldMap.t()) :: :ok
  @callback print(integer) :: none
  @callback lookup(integer, integer, integer) :: Tile.t()

  @world_map [
    "0 0 0 0 0 0 0",
    "0 _ _ _ 0 F 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ _ _ 0",
    "0 H _ _ _ _ 0",
    "0 0 0 0 0 0 0"
  ]

  @world_map [
    "0 0 0 0 0 0 0",
    "0 _ _ _ 0 F 0",
    "0 _ 0 _ 0 _ 0",
    "0 0 0 0 0 _ 0",
    "0 _ F 0 _ _ 0",
    "0 H 0 0 _ _ 0",
    "0 0 0 0 0 0 0"
  ]

  @spec create_world(integer, WorldMap.t()) :: {:ok, home: {integer, integer}}
  def create_world(sim, map \\ @world_map) do
    map
    |> WorldMap.tile_type_of_world_map()
    |> Utils.map_indexed(fn {type, i} ->
         x = WorldMap.x_coord_of_index(i, 7)
         y = WorldMap.y_coord_of_index(i, 7)

         {:ok, _} = TileSupervisor.start_tile(sim, type, x, y)
       end)

    # TODO: Find Home location
    {:ok, home: {1, 1}}
  end

  @spec print(SimId.t()) :: [String.t()]
  def print(sim) do
    all_coords()
    |> Task.async_stream(fn {x, y} ->
         sim
         |> lookup(x, y)
         |> WorldMap.cell_of_tile()
       end)
    |> Enum.map(fn {:ok, cell} -> cell end)
  end

  defdelegate print_tile(tile), to: WorldMap, as: :cell_of_tile

  defdelegate surroundings(sim, x, y), to: Surroundings
  defdelegate lookup(sim, x, y), to: TileLookup
  defdelegate get_tile(sim, x, y), to: TileLookup

  @spec take_food(SimId.t(), integer, integer) :: {:ok, integer} | {:error, :not_food}
  def take_food(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.take_food()
  end

  @spec deposit_food(SimId.t(), integer, integer) :: {:ok, integer} | {:error, :not_home}
  def deposit_food(sim, x, y) do
    IO.inspect({sim, x, y})

    sim
    |> get_tile(x, y)
    |> IO.inspect()
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

  defp decay_pheromones(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.decay_pheromones()
  end

  @spec all_coords :: [{integer, integer}]
  defp all_coords do
    Enum.map(0..6, fn y ->
      Enum.map(0..6, fn x ->
        {x, y}
      end)
    end)
    |> Enum.concat()
  end
end