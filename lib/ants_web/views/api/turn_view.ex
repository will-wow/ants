defmodule AntsWeb.Api.TurnView do
  use AntsWeb, :view

  alias AntsWeb.Api.SimView

  def render("show.json", data) do
    SimView.render("show.json", data)
  end

  def render("done.json", _) do
    %{done: "done"}
  end
end
