defmodule Ants.Ants do
  alias Ants.Simulations.SimId
  alias Ants.Ants.AntSupervisor
  alias Ants.Ants.Ant
  alias Ants.Ants.AntId

  def create_ants(sim, x, y, ants) do
    1..ants
    |> Task.async_stream(fn _ ->
      create_ant(sim, x, y)
    end)
    |> Enum.to_list()
  end

  def create_ant(sim, x, y) do
    id = AntId.next(sim)
    AntSupervisor.start_ant(sim, x, y, id)
  end

  @spec print(SimId.t()) :: [{integer, integer}]
  def print(sim) do
    sim
    |> for_each_ant(&Ant.get/1)
    |> Enum.map(fn {:ok, ant} ->
      {ant.x, ant.y}
    end)
  end

  @spec count_food(SimId.t()) :: integer
  def count_food(sim) do
    sim
    |> for_each_ant(fn ant_id ->
      ant = Ant.get(ant_id)
      if ant.food?, do: 1, else: 0
    end)
    |> Enum.count()
  end

  @spec move_all(SimId.t()) :: any
  def move_all(sim) do
    for_each_ant(sim, &Ant.move/1)
  end

  @spec deposit_all_pheromones(SimId.t()) :: any
  def deposit_all_pheromones(sim) do
    for_each_ant(sim, &Ant.deposit_pheromones/1)
  end

  defp for_each_ant(sim, f) do
    sim
    |> AntId.get()
    |> Task.async_stream(fn id ->
      sim
      |> AntSupervisor.get_ant(id)
      |> f.()
    end)
    |> Enum.to_list()
  end
end
