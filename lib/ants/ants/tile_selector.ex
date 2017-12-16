defmodule Ants.Ants.TileSelector do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Food, Land, Home, Rock}
  alias Ants.Ants.AntMove

  @type rating :: {integer, index}
  @typep location :: AntMove.location()
  @typep index :: Enum.index()
  @typep locations :: [location]

  defmodule RatingMap do
    alias Ants.Ants.TileSelector

    @type t :: %RatingMap{
            food: [TileSelector.rating()],
            land: [TileSelector.rating()],
            home: TileSelector.rating()
          }

    defstruct food: [], land: [], home: nil
  end

  @spec select_tile(locations) :: index
  def select_tile(locations) do
    locations
    |> rating_map_of_tiles()
    |> select_location()
  end

  @spec rating_map_of_tiles(locations) :: RatingMap.t()
  defp rating_map_of_tiles(locations) do
    locations
    |> Enum.reduce(%RatingMap{}, &process_tile/2)
  end

  @spec select_location(RatingMap.t()) :: index
  defp select_location(ratings) do
    case ratings do
      %RatingMap{food: [_ | _]} -> weighted_select(ratings.food)
      %RatingMap{land: [_ | _]} -> weighted_select(ratings.land)
      %RatingMap{home: home} when not is_nil(home) -> home
    end
  end

  @spec process_tile(location, RatingMap.t()) :: RatingMap.t()
  defp process_tile(location = {tile, _i}, ratings) do
    location
    |> rate_location()
    |> update_tile_rating_list(tile, ratings)
  end

  @spec rate_location(location) :: rating
  defp rate_location({tile, i}) do
    {rate_tile(tile), i}
  end

  @spec rate_tile(Tile.t()) :: integer
  defp rate_tile(%Food{food: food}), do: food
  defp rate_tile(%Land{pheromone: pheromone}), do: pheromone + 1
  defp rate_tile(%Home{}), do: 1
  defp rate_tile(%Rock{}), do: 0

  @spec update_tile_rating_list(rating, Tile.t(), RatingMap.t()) :: RatingMap.t()
  defp update_tile_rating_list(rating, tile, ratings) do
    case tile do
      %Food{} ->
        IO.puts("====FOOOOOD====")
        %RatingMap{ratings | food: [rating | ratings.food]}

      %Land{} ->
        %RatingMap{ratings | land: [rating | ratings.land]}

      %Home{} ->
        IO.puts("====HOME====")
        %RatingMap{ratings | home: rating}

      %Rock{} ->
        ratings
    end
  end

  @spec weighted_select([rating]) :: index
  defp weighted_select(ratings) do
    ratings
    |> Enum.map(fn {rating, i} -> repeat(i, rating) end)
    |> Enum.concat()
    |> Enum.random()
  end

  @spec repeat(any, integer) :: [any]
  @spec repeat(any, integer, [any]) :: [any]
  defp repeat(element, count) do
    repeat(element, count, [])
  end

  defp repeat(_element, 0, acc) do
    acc
  end

  defp repeat(element, count, acc) do
    repeat(element, count - 1, [element | acc])
  end
end