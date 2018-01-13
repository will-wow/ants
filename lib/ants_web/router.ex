defmodule AntsWeb.Router do
  use AntsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AntsWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/*path", AppController, :index)
  end

  scope "/api", AntsWeb.Api do
    pipe_through(:api)

    get("/sim", SimController, :index)
    post("/sim", SimController, :create)
    get("/sim/:id", SimController, :show)
    post("/sim/:id/turn", SimController, :turn)
  end
end