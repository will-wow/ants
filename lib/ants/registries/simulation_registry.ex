defmodule Ants.Registries.SimulationRegistry do
  @spec simulation(integer) :: tuple
  def simulation(sim) do
    via({sim, :simulation})
  end

  @spec tile(integer, integer, integer) :: tuple
  def tile(sim, x, y) do
    via({sim, :sim, x, y})
  end

  @spec via(tuple) :: tuple
  defp via(data) do
    {:via, Registry, { __MODULE__, data }}
  end
end