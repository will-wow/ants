defmodule Ants.Ants.AntMove do
  alias Ants.Shared.Knobs
  alias Ants.Ants.Ant
  alias Ants.Ants.Move
  alias Ants.Ants.TileSelector
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Rock, Food, Land}

  @type location :: {Tile.t(), Enum.index()}

  @spec move(Ant.t(), Surroundings.t()) :: Ant.t()
  def move(ant, surroundings) do
    cond do
      ant.food? ->
        go_back_one(ant)

      sees_food?(surroundings) ->
        next_move(ant, surroundings, :food)

      true ->
        next_move(ant, surroundings, :land)
    end
  end

  @spec go_back_one(Ant.t()) :: Ant.t()
  defp go_back_one(ant = %Ant{food?: true}) do
    [hd | tl] = ant.path
    %Ant{ant | x: ant.x - Move.x(hd), y: ant.y - Move.y(hd), path: tl}
  end

  @spec next_move(Ant.t(), Surroundings.t(), TileSelector.tile_type()) :: Ant.t()
  defp next_move(ant, surroundings, tile_type) do
    surroundings
    |> Tuple.to_list()
    |> Stream.with_index()
    |> Enum.filter(&can_visit(ant, &1))
    |> add_forward_location(ant)
    |> TileSelector.select(tile_type)
    |> (fn
          {:ok, index} -> index
          {:error, :blocked} -> last_index(ant)
        end).()
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec can_visit(Ant.t(), location) :: boolean
  defp can_visit(ant, {_tile, i}) do
    # ignore the center tile, and the last move
    !(i == 4 || equals_last_move?(ant, i))
  end

  @spec add_forward_location([location], Ant.t()) :: [location]
  defp add_forward_location(locations, %Ant{path: []}), do: locations

  defp add_forward_location(locations, ant) do
    [move | _] = ant.path

    forward_index = move |> Move.forward_to_index()

    tile = Enum.find(locations, fn {_, i} -> i == forward_index end)

    case tile do
      {%Rock{}, _i} -> locations
      _ -> [{%Land{pheromone: Knobs.get(:forward_weight)}, forward_index} | locations]
    end
  end

  @spec equals_last_move?(Ant.t(), Enum.index()) :: boolean
  defp equals_last_move?(ant, index) do
    case ant.path do
      [] -> false
      [last_move | _] -> Move.backward_to_index(last_move) == index
    end
  end

  defp last_index(ant) do
    case ant.path do
      [] -> raise "ant is trapped!"
      [last_move | _] -> Move.backward_to_index(last_move)
    end
  end

  @spec update_ant_coords(Surroundings.coords(), Ant.t()) :: Ant.t()
  defp update_ant_coords({surrounding_x, surrounding_y}, ant = %Ant{x: x, y: y, path: path}) do
    delta_x = surrounding_x - 1
    delta_y = surrounding_y - 1

    %Ant{ant | x: x + delta_x, y: y + delta_y, path: [{delta_x, delta_y} | path]}
  end

  def sees_food?(surroundings) do
    surroundings
    |> Tuple.to_list()
    |> Enum.any?(fn tile ->
      case tile do
        %Food{} -> true
        _ -> false
      end
    end)
  end
end
