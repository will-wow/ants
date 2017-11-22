defmodule Ants.Worlds.TileSupervisor do
  use Supervisor

  alias Ants.Registries.SimulationRegistry

  alias Ants.Worlds.Tile

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_tile(pid, tile_type) do
    pid = 
    Supervisor.start_child(pid, tile_type)
  end

  def init(:ok) do
    Supervisor.init([Tile], strategy: :simple_one_for_one)
  end
end