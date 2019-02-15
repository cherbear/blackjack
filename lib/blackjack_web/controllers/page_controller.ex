defmodule BlackjackWeb.PageController do
  use BlackjackWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, params) do
    user = get_session(conn, :user)
    if user do
      render conn, "game.html", game: params["game"], user: user
    else
      conn
      |> put_flash(:error, "Must pick a username")
      |> redirect(to: "/")
    end
  end

  def game_form(conn, params) do
    game = params["game"]
    IO.puts game
    conn
    |> put_session(:user, params["user"])
    |> redirect(to: "/game/#{game}")
  end
end
