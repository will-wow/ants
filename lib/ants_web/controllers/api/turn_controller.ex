defmodule AntsWeb.Api.TurnController do
  use AntsWeb, :controller

  alias AntsWeb.Api.FallbackController

  alias Ants.Simulations
  alias Ants.Simulations.SimId

  action_fallback(FallbackController)

  def create(conn, %{"sim_id" => id}) do
    with {sim_id, ""} <- Integer.parse(id),
         true <- SimId.exists?(sim_id),
         world <- Simulations.turn(sim_id) do
      IO.puts("balls")

      conn
      |> render("show.json", sim_id: sim_id, world: world)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render(AntsWeb.ErrorView, :"404")
    end
  end
end