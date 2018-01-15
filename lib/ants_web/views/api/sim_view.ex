defmodule AntsWeb.Api.SimView do
  use AntsWeb, :view

  alias AntsWeb.Api.TileView

  def render("index.json", _) do
    :ok
    # render_many(users, SimView, "index.json")
  end

  def render("show.json", %{sim_id: sim_id, world: world}) do
    %{
      sim_id: sim_id,
      world:
        Enum.map(world, fn row ->
          Enum.map(row, fn cell ->
            TileView.render("show.json", cell)
          end)
        end)
    }
  end
end