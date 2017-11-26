defmodule Ants.Simulations do
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.Simulations.SimId
  alias Ants.Registries.SimulationPubSub
  alias Ants.Worlds

  @spec start :: {:ok, SimId.t}
  def start do
    sim = SimId.get()

    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    :ok = Worlds.create_world(sim)

    {:ok, sim}
  end
end