defmodule Ants.Ants.AntMove do
  alias Ants.Ants.Ant
  alias Ants.Ants.Move
  alias Ants.Ants.TileSelector
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile

  @type location :: {Tile.t(), Enum.index()}

  @spec move(Ant.t(), Surroundings.t()) :: Ant.t()
  def move(ant, surroundings) do
    case ant do
      %Ant{food?: true} -> go_back_one(ant)
      _ -> next_move(ant, surroundings)
    end
  end

  @spec go_back_one(Ant.t()) :: Ant.t()
  defp go_back_one(ant = %Ant{food?: true}) do
    [hd | tl] = ant.path
    %Ant{ant | x: ant.x - Move.x(hd), y: ant.y - Move.y(hd), path: tl}
  end

  @spec next_move(Ant.t(), Surroundings.t()) :: Ant.t()
  defp next_move(ant, surroundings) do
    surroundings
    |> Tuple.to_list()
    |> Stream.with_index()
    |> Enum.filter(&can_visit(ant, &1))
    |> TileSelector.select_tile()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec can_visit(Ant.t(), location) :: boolean
  defp can_visit(ant, {_tile, i}) do
    # ignore the center tile, and the last move
    !(i == 4 || equals_last_move?(ant, i))
  end

  @spec equals_last_move?(Ant.t(), Enum.index()) :: boolean
  defp equals_last_move?(ant, index) do
    case ant.path do
      [] -> false
      [last_move | _] -> Move.to_index(last_move) == index
    end
  end

  @spec update_ant_coords(Surroundings.coords(), Ant.t()) :: Ant.t()
  defp update_ant_coords({surrounding_x, surrounding_y}, ant = %Ant{x: x, y: y, path: path}) do
    delta_x = surrounding_x - 1
    delta_y = surrounding_y - 1

    %Ant{ant | x: x + delta_x, y: y + delta_y, path: [{delta_x, delta_y} | path]}
  end
end