defmodule Ants.Worlds.Tile do
  use GenServer, restart: :transient

  alias Ants.Shared.Utils
  alias Ants.Worlds.TileType

  ## Consts

  @pheromone_decay 0.1

  ## Structs

  defmodule Land do
    defstruct pheromone: 0
  end

  defmodule Rock do
    defstruct []
  end

  defmodule Home do
    defstruct food: 0
  end

  defmodule Food do
    defstruct food: 0
  end

  @type t :: %Land{} | %Rock{} | %Home{} | %Food{}

  ## Client

  def start_link(_, type, opts) do
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
    GenServer.cast(pid, :decay_pheromones)
  end

  ## Server 
  
  def init(type), do: TileType.tile_of_type(type)

  def handle_call(:get, _from, tile) do
    {:reply, tile, tile}
  end


  def handle_call(:take_food, _from, tile = %Food{food: food}) when food > 1 do
    {:reply, {:ok, 1}, Map.update!(tile, :food, &Utils.dec/1)} 
  end

  def handle_call(:take_food, _from, tile = %Food{}) do
    {:reply, {:ok, 1}, %Land{}} 
  end

  def handle_call(:take_food, _from, tile) do
    {:reply, {:error, :not_food}, tile}
  end


  def handle_call(:deposit_pheromones, _from, tile = %Land{pheromone: pheromone}) do
    {:reply, {:ok, 1}, Map.update!(tile, :pheromone, &Utils.inc/1)}
  end

  def handle_call(:deposit_pheromones, _from, tile) do
    {:reply, {:error, :not_land}, tile}
  end


  def handle_call(:deposit_food, _from, tile = %Home{}) do
    {:reply, {:ok}, Map.update!(tile, :food, &Utils.inc/1)}
  end

  def handle_call(:deposit_food, _from, tile) do
    {:reply, {:error, :not_home}, tile}
  end

  
  def handle_call(:decay_pheromones, _from, tile = %Land{pheromone: pheromone}) when pheromone > 0 do
    tile = %Land{tile | pheromone: pheromone * @pheromone_decay}

    {:reply, tile, tile}
  end

  def handle_cast(:decay_pheromones, _from, tile) do
    {:reply, tile, tile}
  end
end
