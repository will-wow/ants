defmodule Ants.Ants.TileSelector do
  alias Ants.Shared.Knobs
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Food, Land, Home, Rock}
  alias Ants.Ants.AntMove
  alias Ants.Shared.Utils

  @type rating :: {integer, index}
  @type tile_type :: :land | :food
  @type on_select :: Utils.maybe(index, :blocked)

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

  @spec select(locations, tile_type) :: on_select
  def select(locations, :land), do: select_land(locations)
  def select(locations, :food), do: select_food(locations)

  @spec select_land(locations) :: on_select
  defp select_land(locations) do
    locations
    |> Enum.filter(fn location ->
         case location do
           {%Land{}, _} -> true
           {%Home{}, _} -> true
           _ -> false
         end
       end)
    |> Enum.map(&rate_location/1)
    |> weighted_select
  end

  @spec select_food(locations) :: on_select
  defp select_food(locations) do
    locations
    |> Enum.filter(fn location ->
         case location do
           {%Food{}, _} -> true
           _ -> false
         end
       end)
    |> Enum.map(&rate_location/1)
    |> weighted_select
  end

  @spec rate_location(location) :: rating
  defp rate_location({tile, i}) do
    {rate_tile(tile), i}
  end

  @spec rate_tile(Tile.t()) :: integer
  defp rate_tile(%Food{food: food}), do: food + 1
  defp rate_tile(%Land{pheromone: pheromone}), do: (pheromone + 1) * pheromone_multiplier()
  defp rate_tile(%Home{}), do: 1
  defp rate_tile(%Rock{}), do: 0

  @spec weighted_select([rating]) :: on_select
  defp weighted_select(ratings) do
    case ratings
         |> Enum.map(&weighted_pair_of_rating/1)
         |> Utils.weighted_select() do
      {:ok, index} -> {:ok, index}
      {:error, _} -> {:error, :blocked}
    end
  end

  defp weighted_pair_of_rating({rating, index}) do
    {index, rating}
  end

  defp pheromone_multiplier() do
    Knobs.get(:pheromone_multiplier)
  end
end