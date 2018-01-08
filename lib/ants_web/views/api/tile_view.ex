defmodule AntsWeb.Api.TileView do
  use AntsWeb, :view

  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.{Land, Food, Home, Rock}

  @type t :: %{
          kind: String.t(),
          ant: boolean,
          tile: Tile.t()
        }

  @spec render(String.t(), any) :: t
  def render("show.json", %{tile: %Land{} = tile, ant: ant}) do
    %{
      kind: "land",
      ant: ant,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Food{} = tile, ant: ant}) do
    %{
      kind: "food",
      ant: ant,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Home{} = tile, ant: ant}) do
    %{
      kind: "home",
      ant: ant,
      tile: tile
    }
  end

  def render("show.json", %{tile: %Rock{} = tile, ant: ant}) do
    %{
      kind: "rock",
      ant: ant,
      tile: tile
    }
  end
end