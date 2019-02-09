defmodule BlackjackWeb.PageController do
  use BlackjackWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  
  def game(conn, params) do
    render(conn, "game.html", name: params["name"])
  end

  def game_form(conn, params) do
    redirect(conn, to: "/game/" <> params["name"])
  end
end
