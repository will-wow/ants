defmodule Ants.Worlds.TileSupervisor do
  use Supervisor

  alias Ants.Worlds.Tile

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_tile(super_pid, tile_type) do
    Supervisor.start_child(super_pid, tile_type)
  end

  def init(:ok) do
    Supervisor.init([Tile], strategy: :simple_one_for_one)
  end
end