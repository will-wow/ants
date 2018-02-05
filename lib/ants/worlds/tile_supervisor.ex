defmodule Ants.Worlds.TileSupervisor do
  use DynamicSupervisor

  @callback get_tile(integer, integer, integer) :: pid

  alias Ants.Shared.SimRegistry
  alias Ants.Worlds.Tile

  def start_link(sim) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: via(sim))
  end

  def start_tile(sim, tile_type, x, y) do
    DynamicSupervisor.start_child(via(sim), {
      Tile,
      {tile_type, [name: tile_via(sim, x, y)]}
    })
  end

  @spec get_tile(integer, integer, integer) :: SimRegistry.t()
  def get_tile(sim, x, y) do
    sim
    |> tile_via(x, y)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp via(sim) do
    SimRegistry.tile_supervisor(sim)
  end

  defp tile_via(sim, x, y) do
    SimRegistry.tile(sim, x, y)
  end
end
