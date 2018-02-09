defmodule Ants.Worlds.Surroundings do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.TileLookup
  alias Ants.Worlds.Point
  alias Ants.Simulations.SimId

  @type t :: [Tile.t()]

  @lookup Application.get_env(:ants, :tile_lookup, TileLookup)

  @spec surroundings(SimId.t(), integer, integer) :: t
  def surroundings(sim, x, y) do
    Enum.map(-1..1, fn delta_y ->
      Enum.map(-1..1, fn delta_x ->
        point_of_offset(x, y, delta_x, delta_y)
      end)
    end)
    |> Enum.concat()
    |> Task.async_stream(fn {x, y} ->
      @lookup.lookup(sim, x, y)
    end)
    |> Enum.map(fn {:ok, tile} -> tile end)
  end

  @spec point_of_offset(Point.x(), Point.y(), integer, integer) :: Point.t()
  defp point_of_offset(x, y, delta_x, delta_y) do
    {x + delta_x, y + delta_y}
  end
end
