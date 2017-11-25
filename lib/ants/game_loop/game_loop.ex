defmodule Ants.GameLoop do
  alias Ants.Registries.SimulationPubSub

  def move(sim) do
    SimulationPubSub.move(sim)
  end

  def evaporate_pheromones(sim) do
    SimulationPubSub.evaporate_pheromones(sim)
  end

  def deposit_pheromones(sim) do
    SimulationPubSub.deposit_pheromones(sim)
  end
end