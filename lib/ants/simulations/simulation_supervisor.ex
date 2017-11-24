defmodule Ants.Simulations.SimulationSupervisor do
  use Supervisor

  alias Ants.Registries.SimRegistry
  alias Ants.Worlds.TileSupervisor

  def start_link(_, sim) do
    Supervisor.start_link(
      __MODULE__,
      sim,
      name: via(sim)
    )
  end

  def init(sim) do
    Supervisor.init([
      {TileSupervisor, sim}
      # AntSupervisor
    ], strategy: :one_for_one)
  end

  defp via(sim) do
    SimRegistry.simulation(sim)
  end
end
