defmodule Ants.Ants.AntMove do
  alias Ants.Shared.Utils
  alias Ants.Ants.Ant
  alias Ants.Ants.Move
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Food, Land, Home, Rock}

  @type location :: {Tile.t, Enum.index}
  @type move :: {integer, integer}

  @spec move(%Ant{}, Surroundings.t) :: %Ant{}
  def move(ant, surroundings) do
    case ant do
      %Ant{food?: true} -> go_back_one(ant)
      _ -> next_move(ant, surroundings)
    end
  end

  @spec go_back_one(%Ant{}) :: %Ant{}
  defp go_back_one(ant = %Ant{food?: true}) do
    [hd|tl] = ant.path
    %Ant{ant | 
      x: ant.x + Move.x(hd),
      y: ant.y + Move.y(hd),
      path: tl
    }
  end

  @spec next_move(%Ant{}, Surroundings.t) :: %Ant{}
  defp next_move(ant, surroundings) do
    surroundings
    |> Tuple.to_list()
    |> Utils.map_indexed(&(rate_or_reject_tile(&1, ant)))
    |> Enum.max_by(fn {rating, i} -> rating end)
    |> get_index()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  defp rate_or_reject_tile({tile, i}, ant) do
    cond do
      # Ants can't stand still
      i == 4 -> {0, i}
      # Ants can't turn around.
      equals_last_move?(ant, i) -> {0, i}
      # Other tiles can be passable.
      true -> {rate_tile(tile), i}
    end
  end

  @spec equals_last_move?(%Ant{}, Enum.index) :: boolean
  defp equals_last_move?(ant, index) do
    case ant.path do
      [] -> false
      [last_move|_] -> Move.to_index(last_move) == index
    end
  end

  @spec rate_tile(Tile.t) :: integer
  defp rate_tile(%Food{}), do: 5
  defp rate_tile(%Land{}), do: random_rating(3)
  defp rate_tile(%Home{}), do: 1
  defp rate_tile(%Rock{}), do: 0

  @spec random_rating(integer) :: float
  defp random_rating(rating) do
    rating + random_decimal()
  end

  @spec random_decimal() :: float
  defp random_decimal() do
    Enum.random(-100..100) / 100
  end

  @spec get_index(location) :: Enum.index
  defp get_index(location), do: elem(location, 1)

  @spec update_ant_coords(Surroundings.coords, %Ant{}) :: %Ant{}
  defp update_ant_coords({surrounding_x, surrounding_y}, ant = %Ant{x: x, y: y}) do
    %Ant{ant | x: x + surrounding_x - 1,
               y: y + surrounding_y - 1 }
  end
end