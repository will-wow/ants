defmodule AntsWeb.SimController do
  use AntsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end