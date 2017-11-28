defmodule Ants.Worlds.TileSupervisor do
  use Supervisor

  @callback get_tile(integer, integer, integer) :: pid

  alias Ants.Registries.SimRegistry

  alias Ants.Worlds.Tile

  def start_link(sim) do
    Supervisor.start_link(__MODULE__, :ok, name: via(sim))
  end

  def start_tile(sim, tile_type, x, y) do
    Supervisor.start_child(via(sim), [tile_type, [name: tile_via(sim, x, y)]])
  end

  @spec get_tile(integer, integer, integer) :: pid
  def get_tile(sim, x, y) do
    sim
    |> tile_via(x, y)
    |> GenServer.whereis()
  end

  def init(:ok) do
    Supervisor.init(
      [Tile],
      strategy: :simple_one_for_one
    )
  end

  defp via(sim) do
    SimRegistry.tile_supervisor(sim)
  end

  defp tile_via(sim, x, y) do
    SimRegistry.tile(sim, x, y)
  end
end
