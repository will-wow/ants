defmodule Ants.GameLoop do
  alias Ants.Registries.SimulationPubSub
  alias Ants.Simulations.SimId

  @spec move(SimId.t) :: :ok
  def move(sim) do
    SimulationPubSub.move(sim)
  end

  @spec evaporate_pheromones(SimId.t) :: :ok
  def evaporate_pheromones(sim) do
    SimulationPubSub.evaporate_pheromones(sim)
  end

  @spec deposit_pheromones(SimId.t) :: :ok
  def deposit_pheromones(sim) do
    SimulationPubSub.deposit_pheromones(sim)
  end
end