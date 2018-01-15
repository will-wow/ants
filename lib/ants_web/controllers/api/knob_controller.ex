defmodule AntsWeb.Api.KnobController do
  use AntsWeb, :controller

  alias AntsWeb.Api.FallbackController

  alias Ants.Simulations

  action_fallback(FallbackController)

  def index(conn, %{"sim_id" => _id}) do
    knobs = Simulations.all_knobs()

    conn
    |> render("index.json", knobs: knobs)
  end

  def show(conn, %{"sim_id" => _id, "id" => name}) do
    case Simulations.knob(name) do
      {:ok, value} ->
        conn
        |> render(
          "show.json", 
          knob: %{
            name => value
          }
        )
    end
  end
end