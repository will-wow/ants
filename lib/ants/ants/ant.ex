defmodule Ants.Ants.Ant do
  use GenServer

  alias __MODULE__ 
  alias Ants.Registries.SimulationPubSub

  ## Consts

  @prob 1

  ## Structs

  defstruct x: nil, y: nil, food?: false, path: []

  ## Client

  def start_link(sim, x, y, opts) do
    GenServer.start_link(__MODULE__, {sim, x, y}, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def move(pid) do
    GenServer.call(pid, :move)
  end

  def deposit_pheromones(pid) do
    GenServer.call(pid, :deposit_pheromones)
  end

  ## Server 
  
  def init({sim, x, y}) do
    SimulationPubSub.register_for_move(sim)
    {:ok, %Ant{x: x, y: y}}
  end

  def handle_call(:get, _from, ant) do
    {:reply, ant, ant}
  end

  def handle_cast(:move, _from, ant) do
    {:noreply, ant}
  end

  def handle_cast(:deposit_pheromones, _from, ant) do
    {:noreply, ant}
  end
end