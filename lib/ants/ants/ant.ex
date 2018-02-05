defmodule Ants.Ants.Ant do
  use GenServer

  alias __MODULE__
  alias Ants.Ants.AntMove
  alias Ants.Ants.AntFood
  alias Ants.Worlds
  alias Ants.Simulations.SimId

  @type t :: %Ant{
          x: integer,
          y: integer,
          food?: boolean
        }

  @type state :: {SimId.t(), Ant.t()}

  defstruct x: nil, y: nil, food?: false

  ## Client

  def start_link({sim, x, y, opts}) do
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
    {:ok, {sim, %Ant{x: x, y: y}}}
  end

  @spec handle_call(:get | :move | :deposit_pheromones, any, state) :: {:reply, Ant.t(), state}
  def handle_call(:get, _from, state = {_, ant}) do
    {:reply, ant, state}
  end

  def handle_call(:move, _from, {sim, ant}) do
    x = ant.x
    y = ant.y
    surroundings = Worlds.surroundings(sim, x, y)

    ant =
      ant
      |> AntMove.move(surroundings)
      |> AntFood.deposit_food(sim)
      |> AntFood.take_food(sim)

    {:reply, ant, {sim, ant}}
  end

  def handle_call(:deposit_pheromones, _from, {sim, ant}) do
    AntFood.deposit_pheromones(ant, sim)
    {:reply, ant, {sim, ant}}
  end

  def terminate(reason, state) do
    IO.inspect({"ant killed!", reason, state})
  end
end
