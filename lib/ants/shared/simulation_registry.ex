defmodule Ants.Shared.SimRegistry do
  @spec simulation(integer) :: tuple
  def simulation(sim) do
    via({sim, :sim})
  end

  @spec tile_supervisor(integer) :: Supervisor.name()
  def tile_supervisor(sim) do
    via({sim, :tile_supervisor})
  end

  @spec ant_supervisor(integer) :: Supervisor.name()
  def ant_supervisor(sim) do
    via({sim, :ant_supervisor})
  end

  @spec tile(integer, integer, integer) :: Supervisor.name()
  def tile(sim, x, y) do
    via({sim, :tile, x, y})
  end

  @spec ant(integer, integer) :: Supervisor.name()
  def ant(sim, id) do
    via({sim, :ant, id})
  end

  @spec ant_id(integer) :: Supervisor.name()
  def ant_id(sim) do
    via({sim, :ant_id})
  end

  @spec via(tuple) :: Supervisor.name()
  defp via(data) do
    {:via, Registry, {__MODULE__, data}}
  end
end
