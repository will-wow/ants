defmodule Ants.Tile do
  use GenServer

  ## Consts

  @starting_food 10

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

  ## Client

  def start_link(type, opts) do
    GenServer.start_link(__MODULE__, type, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def add_pheromone(pid) do
    GenServer.call(pid, :add_pheromone)
  end

  def take_food(pid) do
    GenServer.call(pid, :take_food)
  end

  def deposit_food(pid) do
    GenServer.call(pid, :deposit_food)
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  ## Server 
  
  def init(:land), do: {:ok, %Land{}}
  def init(:rock), do: {:ok, %Rock{}}
  def init(:home), do: {:ok, %Home{}}
  def init(:food), do: {:ok, %Food{food: @starting_food}}
  def init(_),     do: {:error, :bad_type}

  def handle_call(:get, _from, tile) do
    {:reply, tile, tile}
  end


  def handle_call(:take_food, _from, tile = %Food{food: food}) when food > 1 do
    {:reply, {:ok, 1}, Map.update!(tile, :food, &dec/1)} 
  end

  def handle_call(:take_food, _from, tile = %Food{}) do
    {:reply, {:ok, 1}, %Land{}} 
  end

  def handle_call(:take_food, _from, tile) do
    {:reply, {:error, :not_food}, tile}
  end


  def handle_call(:add_pheromone, _from, tile = %Land{pheromone: pheromone}) do
    {:reply, {:ok}, Map.update!(tile, :pheromone, &inc/1)}
  end

  def handle_call(:add_pheromone, _from, tile) do
    {:reply, {:error, :not_land}, tile}
  end


  def handle_call(:deposit_food, _from, tile = %Home{food: food}) do
    {:reply, {:ok}, %Home{food: food + 1}}
  end

  def handle_call(:deposit_food, _from, tile) do
    {:reply, {:error, :not_home}, tile}
  end

  
  def handle_call(:tick, _from, tile = %Land{pheromone: pheromone}) when pheromone > 0 do
    {:reply, {:ok}, %Land{pheromone: pheromone - 1}}
  end

  def handle_call(:tick, _from, tile) do
    {:reply, {:ok}, tile}
  end

  defp inc(n), do: n + 1

  defp dec(n), do: n - 1
end
