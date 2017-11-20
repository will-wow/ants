defmodule Ants.Simulations.SimulationRegistry do

  alias Ants.Simulations.SimulationsRegistry

  def spec(sim_id) do
    {
      Registry, 
      keys: :unique,
      name: registry(sim_id)
    }
  end

  def registry(sim_id) do
    {:via, Registry, {
      SimulationsRegistry.registry,
      sim_id
    }}
  end

  def name(sim_id, kind) do
    {:via, Registry, {
      registry(sim_id),
      kind
    }}
  end
end
