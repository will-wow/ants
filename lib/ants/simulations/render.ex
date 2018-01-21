defmodule Ants.Simulations.Render do
  alias __MODULE__
  alias Ants.Shared.Knobs
  alias Ants.Shared.Utils
  alias Ants.Worlds
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Point
  alias Ants.Simulations.SimId
  alias Ants.Ants

  @map_size Knobs.constant(:map_size)

  @type t :: %Render{tile: Tile.t(), ant: boolean}
  @type world :: [[t]]

  defstruct [:tile, :ant]

  @spec data(SimId.t()) :: world
  def data(sim) do
    tiles = Worlds.all_tiles(sim)
    ants = Ants.print(sim)

    ant_indexes =
      ants
      |> Enum.map(&Point.to_index(&1, @map_size))

    tiles
    |> Utils.map_indexed(fn {tile, i} ->
      %{
        tile: tile,
        ants: ant?(ant_indexes, i)
      }
    end)
    |> Stream.chunk_every(@map_size)
    |> Enum.reverse()
  end

  defp ant?(ant_indexes, i) do
    Enum.member?(ant_indexes, i)
  end
end