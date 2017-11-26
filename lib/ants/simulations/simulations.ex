defmodule Ants.Simulations do
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.Simulations.SimId
  alias Ants.Registries.SimulationPubSub
  alias Ants.Worlds
  alias Ants.Ants

  @spec start :: {:ok, SimId.t}
  def start do
    sim = SimId.get()

    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    {:ok, home: {home_x, home_y}} = Worlds.create_world(sim)

    Ants.create_ants(sim, home_x, home_y)

    {:ok, sim}
  end

  @spec turn(SimId.t) :: :ok
  def turn(sim) do
    Ants.move_all(sim)
    Ants.deposit_all_pheromones(sim)
    Worlds.decay_all_pheromones(sim)

    :ok
  end
end