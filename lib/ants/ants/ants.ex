defmodule Ants.Ants do
  alias Ants.Simulations.SimId
  alias Ants.Ants.AntSupervisor
  alias Ants.Ants.Ant
  alias Ants.Ants.AntId

  def create_ants(sim, x, y) do
    0..10
    |> Task.async_stream(fn _ ->
      create_ant(sim, x, y)
    end)
    |> Enum.to_list
  end

  def create_ant(sim, x, y) do
    id = AntId.next(sim)
    AntSupervisor.start_ant(sim, x, y, id)
  end  

  @spec print(SimId.t) :: [{integer, integer}]
  def print(sim) do
    sim
    |> AntId.get()
    |> Task.async_stream(fn id ->
      get(sim, id)
    end)
    |> Enum.map(fn {:ok, ant} ->
      {ant.x, ant.y}
    end)
  end

  @spec move_all(SimId.t) :: any
  def move_all(sim) do
    sim
    |> AntId.get()
    |> Task.async_stream(fn id ->
      move(sim, id)
    end)
    |> Enum.to_list
  end

  @spec deposit_all_pheromones(SimId.t) :: any
  def deposit_all_pheromones(sim) do
    sim
    |> AntId.get()
    |> Task.async_stream(fn id ->
      deposit_pheromones(sim, id)
    end)
    |> Enum.to_list
  end

  @spec get(SimId.t, integer) :: Ant.t
  defp get(sim, id) do
    sim
    |> AntSupervisor.get_ant(id)
    |> Ant.get()
  end

  @spec move(SimId.t, integer) :: Ant.t
  defp move(sim, id) do
    sim
    |> AntSupervisor.get_ant(id)
    |> Ant.move()
  end

  @spec deposit_pheromones(SimId.t, integer) :: {:ok, integer}
  defp deposit_pheromones(sim, id) do
    sim
    |> AntSupervisor.get_ant(id)
    |> Ant.deposit_pheromones()
  end
end