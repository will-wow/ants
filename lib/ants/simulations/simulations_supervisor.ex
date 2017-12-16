defmodule Ants.Simulations.SimulationsSupervisor do
  use DynamicSupervisor

  alias Ants.Simulations.SimulationSupervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec start_simulation(integer) :: Supervisor.on_start_child()
  def start_simulation(sim) do
    DynamicSupervisor.start_child(__MODULE__, {SimulationSupervisor, sim})
  end

  @spec end_simulation(integer) :: Supervisor.on_start_child()
  def end_simulation(sim) do
    child_pid =
      sim
      |> SimulationSupervisor.via()
      |> GenServer.whereis()

    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end