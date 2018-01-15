defmodule AntsWeb.Api.TileView do
  use AntsWeb, :view

  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Land, Food, Home, Rock}

  @type t :: %{
          kind: String.t(),
          ants: boolean,
          tile: Tile.t()
        }

  @spec render(String.t(), any) :: t
  def render("show.json", %{tile: %Land{} = tile, ants: ants}) do
    %{
      kind: "land",
      ants: ants,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Food{} = tile, ants: ants}) do
    %{
      kind: "food",
      ants: ants,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Home{} = tile, ants: ants}) do
    %{
      kind: "home",
      ants: ants,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Rock{} = tile, ants: ants}) do
    %{
      kind: "rock",
      ants: ants,
      tile: tile
    }
  end
end
