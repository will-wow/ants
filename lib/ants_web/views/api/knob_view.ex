defmodule AntsWeb.Api.KnobView do
  use AntsWeb, :view

  def render("index.json", %{knobs: knobs}) do
    knobs
  end

  def render("show.json", %{knob: data}) do
    data
  end
end