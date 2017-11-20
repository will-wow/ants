defmodule Ants.Worlds.WorldRegistry do
  alias Ants.Simulations.SimulationRegistry

  def spec(sim_id) do
    {
      Registry, 
      keys: :unique,
      name: registry(sim_id)
    }
  end

  def registry(sim_id, x, y) do
    {:via, Registry, {
      SimulationRegistry.registry(sim_id)
      {x, y}
    }}
  end

  def name(sim_id, kind) do
    {:via, Registry, {
      registry(sim_id),
      kind
    }}
  end
end

