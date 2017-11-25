defmodule Ants.Worlds.TileLookup do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileSupervisor

  @callback lookup(integer, integer, integer) :: Tile.t
  @callback get_tile(integer, integer, integer) :: pid

  def lookup(sim, x, y) do
    sim
    |> get_tile(x, y)
    |> Tile.get()
  end

  defdelegate get_tile(sim, x, y), to: TileSupervisor
end