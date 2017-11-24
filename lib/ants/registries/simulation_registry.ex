defmodule Ants.Registries.SimRegistry do
  @spec simulation(integer) :: tuple
  def simulation(sim) do
    via({sim, :sim})
  end

  @spec tile_supervisor(integer) :: tuple
  def tile_supervisor(sim) do
    via({sim, :tile_supervisor})
  end

  @spec tile(integer, integer, integer) :: tuple
  def tile(sim, x, y) do
    via({sim, :tile, x, y})
  end

  @spec via(tuple) :: tuple
  defp via(data) do
    {:via, Registry, { __MODULE__, data }}
  end
end