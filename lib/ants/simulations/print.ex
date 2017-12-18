defmodule Ants.Simulations.Print do
  alias Ants.Shared.Utils
  alias Ants.Worlds.Surroundings
  alias Ants.Simulations.SimId
  alias Ants.Worlds
  alias Ants.Ants

  @map_size 10

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

  defp replace_tile_with_ant(ant_indexes, tile, i) do
    if Enum.member?(ant_indexes, i) do
      "X"
    else
      tile
    end
  end
end