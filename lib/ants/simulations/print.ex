defmodule Ants.Simulations.Print do
  alias __MODULE__
  alias Ants.Shared.Knobs
  alias Ants.Shared.Utils
  alias Ants.Worlds
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Surroundings
  alias Ants.Simulations.SimId
  alias Ants.Ants

  @map_size Knobs.constant(:map_size)

  @type t :: %Print{tile: Tile.t(), ant: boolean}
  @type world :: [[t]]

  defstruct [:tile, :ant]

  @spec data(SimId.t()) :: world
  def data(sim) do
    tiles = Worlds.all_tiles(sim)
    ants = Ants.print(sim)

    ant_indexes =
      ants
      |> Enum.map(fn {x, y} ->
        Surroundings.index_of_coords(x, y, @map_size)
      end)

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

  @spec print(SimId.t()) :: :ok
  def print(sim) do
    tiles = Worlds.print(sim)
    ants = Ants.print(sim)

    ant_indexes =
      ants
      |> Enum.map(fn {x, y} ->
        Surroundings.index_of_coords(x, y, @map_size)
      end)

    tiles
    |> Utils.map_indexed(fn {tile, i} ->
      replace_tile_with_ant(ant_indexes, tile, i)
    end)
    |> Stream.chunk_every(@map_size)
    |> Enum.reverse()
    |> Enum.map_join("\n", &Enum.join(&1, " "))
    |> IO.puts()
  end

  defp ant?(ant_indexes, i) do
    Enum.member?(ant_indexes, i)
  end

  defp replace_tile_with_ant(ant_indexes, tile, i) do
    if Enum.member?(ant_indexes, i) do
      "X"
    else
      tile
    end
  end
end
