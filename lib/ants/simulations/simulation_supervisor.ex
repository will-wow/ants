defmodule Ants.Simulations.SimulationSupervisor do
  use Supervisor

  alias Ants.Shared.SimRegistry
  alias Ants.Worlds.TileSupervisor
  alias Ants.Ants.AntSupervisor
  alias Ants.Ants.AntId

  def start_link(sim) do
    Supervisor.start_link(
      __MODULE__,
      sim,
      name: via(sim)
    )
  end

  def init(sim) do
    Supervisor.init(
      [
        {TileSupervisor, sim},
        {AntSupervisor, sim},
        {AntId, sim}
      ],
      strategy: :one_for_one
    )
  end

  def via(sim) do
    SimRegistry.simulation(sim)
  end
end
