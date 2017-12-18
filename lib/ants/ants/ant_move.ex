defmodule Ants.Ants.AntMove do
  alias Ants.Ants.Ant
  alias Ants.Ants.Move
  alias Ants.Ants.TileSelector
  alias Ants.Worlds.Surroundings
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Rock, Food}

  @type location :: {Tile.t(), Enum.index()}

  @spec move(Ant.t(), Surroundings.t()) :: Ant.t()
  def move(ant, surroundings) do
    cond do
      ant.food? ->
        go_back_one(ant)

      sees_food?(surroundings) ->
        choose_new_direction(ant, surroundings, :food)

      true ->
        next_move(ant, surroundings)
    end
  end

  @spec next_move(Ant.t(), Surroundings.t()) :: Ant.t()
  def next_move(ant, surroundings) do
    case try_forward(ant, surroundings) do
      :blocked ->
        choose_new_direction(ant, surroundings, :land)

      {x, y} = move ->
        %Ant{ant | x: ant.x + x, y: ant.y + y, path: [move | ant.path]}
    end
  end

  @spec go_back_one(Ant.t()) :: Ant.t()
  defp go_back_one(ant = %Ant{food?: true}) do
    [hd | tl] = ant.path
    %Ant{ant | x: ant.x - Move.x(hd), y: ant.y - Move.y(hd), path: tl}
  end

  @spec choose_new_direction(Ant.t(), Surroundings.t(), TileSelector.tile_type()) :: Ant.t()
  defp choose_new_direction(ant, surroundings, tile_type) do
    surroundings
    |> Tuple.to_list()
    |> Stream.with_index()
    |> Enum.filter(&can_visit(ant, &1))
    |> TileSelector.select(tile_type)
    |> Surroundings.coords_of_index()
    |> update_ant_coords(ant)
  end

  @spec can_visit(Ant.t(), location) :: boolean
  defp can_visit(ant, {_tile, i}) do
    # ignore the center tile, and the last move
    !(i == 4 || equals_last_move?(ant, i))
  end

  @spec try_forward(Ant.t(), Surroundings.t()) :: Move.t() | :blocked
  defp try_forward(%Ant{path: []}, _) do
    :blocked
  end

  defp try_forward(ant, surroundings) do
    [move | _] = ant.path

    index = Move.forward_to_index(move)

    case elem(surroundings, index) do
      %Rock{} -> :blocked
      _ -> move
    end
  end

  @spec equals_last_move?(Ant.t(), Enum.index()) :: boolean
  defp equals_last_move?(ant, index) do
    case ant.path do
      [] -> false
      [last_move | _] -> Move.backward_to_index(last_move) == index
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