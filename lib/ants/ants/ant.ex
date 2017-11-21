defmodule Ants.Ants.Ant do
  use GenServer

  alias Ants.Ants.Ant

  ## Consts

  @prob 1

  ## Structs

  defstruct x: nil, y: nil, food?: false, path: []

  ## Client

  def start_link({x, y}, opts) do
    GenServer.start_link(__MODULE__, {x, y}, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def move(pid) do
    GenServer.call(pid, :tick)
  end

  def deposit_pheromones(pid) do
    GenServer.call(pid, :deposit_pheromones)
  end

  ## Server 
  
  def init({x, y}), do: {:ok, %Ant{x: x, y: y}}

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