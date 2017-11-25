defmodule Ants.Worlds.TileType do
  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Land, Rock, Home, Food}

  @type t :: :land | :rock | :home | :food
  @type on_tile_of_type :: {:ok, Tile.t} | {:error, :bad_type}

  @starting_food 10

  @spec tile_of_type(t) :: on_tile_of_type
  def tile_of_type(:land), do: {:ok, %Land{}}
  def tile_of_type(:rock), do: {:ok, %Rock{}}
  def tile_of_type(:home), do: {:ok, %Home{}}
  def tile_of_type(:food), do: {:ok, %Food{food: @starting_food}}
  def tile_of_type(type),     do: {:error, :bad_type, type}
end