defmodule Ants.Ants.AntMove do
  alias Ants.Ants.Ant
  alias Ants.Ants.Move
  alias Ants.Ants.ToHome
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
    move = ToHome.backwards_move({x, y})
    new_local_index = Move.forward_to_index(move)
    tile = Enum.at(surroundings, new_local_index)

    case tile do
      %Rock{} -> next_move(ant, surroundings)
      _ -> move_ant(move, ant)
    end
  end

  @spec next_move(Ant.t(), Surroundings.t()) :: Ant.t()
  defp next_move(ant, surroundings) do
    tile_type = if sees_food?(surroundings), do: :food, else: :land

    surroundings
    |> Stream.with_index()
    |> Enum.filter(&can_visit/1)
    |> TileSelector.select(tile_type)
    |> (fn
          {:ok, index} -> index
          {:error, :blocked} -> raise "ant is trapped!"
        end).()
    |> update_ant_coords(ant)
  end

  @spec can_visit(location) :: boolean
  defp can_visit({tile, i}) do
    case tile do
      %Rock{} -> false
      _ -> !(i == @center_tile_index)
    end
  end

  @spec update_ant_coords(Enum.index(), Ant.t()) :: Ant.t()
  defp update_ant_coords(local_index, ant = %Ant{}) do
    local_index
    |> Move.from_index()
    |> move_ant(ant)
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

  @spec move_ant(Move.t(), Ant.t()) :: Ant.t()
  defp move_ant({delta_x, delta_y}, ant = %Ant{x: x, y: y}) do
    %Ant{ant | x: x + delta_x, y: y + delta_y}
  end
end
