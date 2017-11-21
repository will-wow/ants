defmodule Ants.Registries.SimulationRegistry do
  @spec tile(integer) :: tuple
  def simulation(sim_id) do
    via({sim_id, :simulation})
  end

  @spec tile(integer, integer, integer) :: tuple
  def tile(sim_id, x, y) do
    via({sim_id, :sim_id, x, y})
  end

  @spec via(tuple) :: tuple
  defp via(data) do
    {:via, Registry, { __MODULE__, data }}
  end
end