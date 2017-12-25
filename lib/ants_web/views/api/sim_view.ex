defmodule AntsWeb.Api.SimView do
  use AntsWeb, :view
  alias AntsWeb.Api.SimView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, SimView, "index.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, SimView, "user.json")}
  end

  def render("sim.json", %{user: user}) do
    %{id: user.id, name: user.name, age: user.age}
  end

  def render("world.json", %{user: user}) do
    %{id: user.id, name: user.name, age: user.age}
  end
end