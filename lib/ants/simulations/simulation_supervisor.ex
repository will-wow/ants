defmodule Ants.Simulations.SimulationSupervisor do
  use Supervisor

  alias Ants.Simulation.SimulationsRegistry
  alias Ants.Simulation.SimulationRegistry

  def start_link(sim_id, opts \\ []) do
    Supervisor.start_link(__MODULE__, sim_id, opts)
  end

  def init(sim_id) do
    Supervisor.init([
      SimulationRegistry.spec(sim_id),


      
      # SimulationDispatcher
      # TileRegistry
      # TileSupervisor
      # AntSupervisor
    ], :one_for_one)
  end
end
