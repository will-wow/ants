defmodule Ants.Ants.AntMove do
  alias Ants.Ants.Ant
  alias Ants.Ants.AntReturn
  alias Ants.Ants.Move
  alias Ants.Ants.TileSelector
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Rock, Food}

  @type location :: {Tile.t(), Enum.index()}

  @center_tile_index 4

  @spec move(Ant.t(), Surroundings.t()) :: Ant.t()
  def move(ant = %Ant{food?: true}, surroundings) do
    move_toward_home(ant, surroundings)
  end

  def move(ant = %Ant{food?: false}, surroundings) do
    next_move(ant, surroundings)
  end

  @spec move_toward_home(Ant.t(), Surroundings.t()) :: Ant.t()
  defp move_toward_home(ant = %Ant{food?: true, x: x, y: y}, surroundings) do
    move = AntReturn.backwards_move(x, y)
    new_local_index = Move.forward_to_index(move)
    tile = Enum.at(surroundings, new_local_index)

    case tile do
      %Rock{} -> next_move(ant, surroundings)
      _ -> move_ant(ant, move)
    end
  end

  @spec next_move(Ant.t(), Surroundings.t()) :: Ant.t()
  defp next_move(ant, surroundings) do
    tile_type = if sees_food?(surroundings), do: :food, else: :land

    surroundings
    |> Stream.with_index()
    |> Enum.filter(&can_visit(ant, &1))
    |> TileSelector.select(tile_type)
    |> (fn
          {:ok, index} -> index
          {:error, :blocked} -> last_index(ant)
        end).()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec can_visit(Ant.t(), location) :: boolean
  defp can_visit(ant, {tile, i}) do
    case tile do
      %Rock{} -> false
      _ -> !(i == @center_tile_index || equals_last_move?(ant, i))
    end
  end

  @spec equals_last_move?(Ant.t(), Enum.index()) :: boolean
  defp equals_last_move?(ant, index) do
    case ant.last do
      nil -> false
      last_move -> Move.backward_to_index(last_move) == index
    end
  end

  defp last_index(ant) do
    case ant.last do
      nil -> raise "ant is trapped!"
      last_move -> Move.backward_to_index(last_move)
    end
  end

  @spec update_ant_coords(Surroundings.coords(), Ant.t()) :: Ant.t()
  defp update_ant_coords({surrounding_x, surrounding_y}, ant = %Ant{}) do
    move = {surrounding_x - 1, surrounding_y - 1}

    move_ant(ant, move)
  end

  defp sees_food?(surroundings) do
    surroundings
    |> Enum.any?(fn tile ->
      case tile do
        %Food{} -> true
        _ -> false
      end
    end)
  end

  @spec move_ant(Ant.t(), Move.t()) :: Ant.t()
  defp move_ant(ant = %Ant{x: x, y: y}, move = {delta_x, delta_y}) do
    %Ant{ant | x: x + delta_x, y: y + delta_y, last: move}
  end
end
