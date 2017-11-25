defmodule Ants.Simulations.SimulationsSupervisor do
  use Supervisor

  alias Ants.Simulations.SimulationSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_simulation(sim) do
    Supervisor.start_child(__MODULE__, [sim])
  end

  def end_simulation(sim) do
    child_via = SimulationSupervisor.via(sim)
    Supervisor.terminate_child(__MODULE__, child_via)
  end

  def init(:ok) do
    Supervisor.init([
      SimulationSupervisor
    ], strategy: :simple_one_for_one)
  end
end
