defmodule Ants.Simulations.SimulationSupervisor do
  use Supervisor

  alias Ants.Simulation.SimulationRegistry

  def start_link(sim, opts \\ []) do
    Supervisor.start_link(__MODULE__, sim, opts)
  end

  def init(sim) do
    Supervisor.init([
      # TileSupervisor
      # AntSupervisor
    ], :one_for_one)
  end

  defp register(sim) do
    {:ok, _} = Registry.register(
      SimulationRegistry,
      SimulationRegistry.simulation(sim),
      []
    )
  end
end
