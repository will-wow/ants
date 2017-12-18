defmodule Ants.Simulations do
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.Simulations.SimId
  alias Ants.Simulations.Print
  alias Ants.Worlds
  alias Ants.Ants

  @spec start :: {:ok, SimId.t()}
  @spec start(integer) :: {:ok, SimId.t()}
  def start(ants \\ 10) do
    sim = SimId.get()

    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    {:ok, home: {home_x, home_y}} = Worlds.create_world(sim)

    Ants.create_ants(sim, home_x, home_y, ants)

    {:ok, sim}
  end

  @spec turn(SimId.t()) :: :ok
  @spec turn(SimId.t(), integer) :: :ok
  def turn(sim, turns \\ 1) do
    Enum.each(1..turns, fn _ ->
      end_if_done(sim)
      Ants.move_all(sim)
      Ants.deposit_all_pheromones(sim)
      Worlds.decay_all_pheromones(sim)
    end)

    print(sim)

    :ok
  end

  @spec end_if_done(SimId.t()) :: :ok
  def end_if_done(sim) do
    if done?(sim) do
      SimulationsSupervisor.end_simulation(sim)
      IO.puts("====DONE!====")
      :ok
    else
      :ok
    end
  end

  @spec done?(SimId.t()) :: boolean
  def done?(sim) do
    food_in_world = Worlds.count_food(sim)
    food_with_ants = Ants.count_food(sim)

    food_in_world + food_with_ants <= 0
  end

  defdelegate print(sim), to: Print
end