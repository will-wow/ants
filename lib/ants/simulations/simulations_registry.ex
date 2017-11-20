defmodule Ants.Simulations.SimulationsRegistry do
  def spec
    {
      Registry, 
      keys: :unique,
      name: registry()
    }
  end

  def registry do
    __MODULE__
  end

  def name(sim_id) do
    {:via, Registry, {
      registry(),
      sim_id
    }}
  end
end