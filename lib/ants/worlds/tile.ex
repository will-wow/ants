defmodule Ants.Worlds.Tile do
  use GenServer, restart: :transient

  alias Ants.Shared.Utils
  alias Ants.Shared.Knobs
  alias Ants.Worlds.TileType

  ## Structs

  defmodule Land do
    @type t :: %Land{pheromone: float}
    defstruct pheromone: 0
  end

  defmodule Rock do
    @type t :: %Rock{}
    defstruct []
  end

  defmodule Home do
    @type t :: %Home{food: integer}
    defstruct food: 0
  end

  defmodule Food do
    @type t :: %Food{food: integer}
    defstruct food: 0
  end

  @type t :: Land.t() | Rock.t() | Home.t() | Food.t()

  ## Client

  def start_link({type, opts}) do
    GenServer.start_link(__MODULE__, type, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def deposit_pheromones(pid) do
    GenServer.call(pid, :deposit_pheromones)
  end

  def take_food(pid) do
    GenServer.call(pid, :take_food)
  end

  def deposit_food(pid) do
    GenServer.call(pid, :deposit_food)
  end

  def decay_pheromones(pid) do
    GenServer.call(pid, :decay_pheromones)
  end

  ## Server 

  def init(type), do: TileType.tile_of_type(type)

  def handle_call(:get, _from, tile) do
    {:reply, tile, tile}
  end

  def handle_call(:take_food, _from, tile = %Food{food: food}) when food > 1 do
    {:reply, {:ok, 1}, Map.update!(tile, :food, &Utils.dec/1)}
  end

  def handle_call(:take_food, _from, %Food{}) do
    {:reply, {:ok, 1}, %Land{}}
  end

  def handle_call(:take_food, _from, tile) do
    {:reply, {:error, :not_food}, tile}
  end

  def handle_call(:deposit_pheromones, _from, tile = %Land{}) do
    {:reply, {:ok}, Map.update!(tile, :pheromone, Utils.inc_by(pheromone_deposit()))}
  end

  def handle_call(:deposit_pheromones, _from, tile) do
    {:reply, {:error, :not_land}, tile}
  end

  def handle_call(:deposit_food, _from, tile = %Home{}) do
    {:reply, {:ok, 1}, Map.update!(tile, :food, &Utils.inc/1)}
  end

  def handle_call(:deposit_food, _from, tile) do
    {:reply, {:error, :not_home}, tile}
  end

  def handle_call(:decay_pheromones, _from, tile = %Land{pheromone: pheromone}) when pheromone > 0 do
    tile = %Land{tile | pheromone: (1 - pheromone_evaporation_coefficient()) * pheromone}

    {:reply, tile, tile}
  end

  def handle_call(:decay_pheromones, _from, tile) do
    {:reply, tile, tile}
  end

  @spec pheromone_evaporation_coefficient() :: float
  defp pheromone_evaporation_coefficient do
    Knobs.get(:pheromone_evaporation_coefficient)
  end

  defp pheromone_deposit do
    Knobs.get(:pheromone_deposit)
  end
end
