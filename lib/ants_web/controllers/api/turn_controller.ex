defmodule AntsWeb.Api.TurnController do
  use AntsWeb, :controller

  alias AntsWeb.Api.FallbackController

  alias Ants.Simulations
  alias Ants.Simulations.SimId

  action_fallback(FallbackController)

  def create(conn, %{"sim_id" => id}) do
    with {sim_id, ""} <- Integer.parse(id),
         true <- SimId.exists?(sim_id),
         {:ok, world} <- Simulations.turn(sim_id) do
      conn
      |> render("show.json", sim_id: sim_id, world: world)
    else
      {:error, :done} ->
        conn
        |> put_status(201)
        |> render("done.json", [])

      _ ->
        {:error, :not_found}
    end
  end
end
