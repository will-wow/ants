defmodule AntsWeb.Api.TileView do
  use AntsWeb, :view

  alias Ants.Worlds.Tile.{Land, Food, Home, Rock}

  @type t :: land | food | home | rock

  @type land :: %{kind: String.t(), ant: boolean, pheromone: integer}
  @type food :: %{kind: String.t(), ant: boolean, food: integer}
  @type home :: %{kind: String.t(), ant: boolean, food: integer}
  @type rock :: %{kind: String.t(), ant: boolean}

  @spec render(String.t(), any) :: t
  def render("show.json", %{tile: %Land{} = tile, ant: ant}) do
    %{
      kind: "land",
      ant: ant,
      pheromone: tile.pheromone
    }
  end

  def render("show.json", %{tile: %Food{} = tile, ant: ant}) do
    %{
      kind: "food",
      ant: ant,
      food: tile.food
    }
  end

  def render("show.json", %{tile: %Rock{}, ant: ant}) do
    %{
      kind: "rock",
      ant: ant
    }
  end

  def render("show.json", %{tile: %Home{} = tile, ant: ant}) do
    %{
      kind: "home",
      ant: ant,
      food: tile.food
    }
  end
end