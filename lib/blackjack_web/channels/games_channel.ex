defmodule BlackjackWeb.GamesChannel do
  use BlackjackWeb, :channel
  alias Blackjack.Game
  alias Blackjack.BackupAgent

  intercept ["update"]

  def join("games:" <> game_name, %{"user" => user}, socket) do
    IO.puts("NAME #{user}")
    if authorized?(user) do
      IO.puts("Joining...")
      game = BackupAgent.get(game_name) || Game.new(game_name)
      game = Game.userJoin(game, user)
      IO.inspect(game)
      socket = socket
      |> assign(:game, game_name)
      |> assign(:user, user)
      BackupAgent.put(game_name, game)
      {:ok, %{"join" => game_name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("hit", payload, socket) do
    game_name = socket.assigns[:game]
    game = BackupAgent.get(game_name)
    |> Game.hit
    BackupAgent.put(game_name, game)
    broadcast!(socket, "update", %{game: game})
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("stand", payload, socket) do
    game_name = socket.assigns[:game]
    game = BackupAgent.get(game_name)
    |> Game.stand
    BackupAgent.put(game_name, game)
    broadcast!(socket, "update", %{game: game})
    {:reply, {:ok, %{"game" => game}}, socket}
  end
  
  def handle_in("update", payload, socket) do
    IO.puts("Handling In! Update!")
    game = %{
      player1: payload["player1"],
      player1Name: payload["player1Name"],
      prevPlayer1Sum: payload["prevPlayer1Sum"],
      player1Sum: payload["player1Sum"],
      player1Score: payload["player1Score"],
      player2: payload["player2"],
      player2Name: payload["player2Name"],
      prevPlayer2Sum: payload["prevPlayer2Sum"],
      player2Sum: payload["player2Sum"],
      player2Score: payload["player2Score"],
      playerTurn: payload["playerTurn"],
      round: payload["round"],
      name: payload["name"],
      win: payload["win"],
    }
    IO.puts("handle_in_broadcast_1")
    broadcast!(socket, "update", %{game: game})
    IO.puts("handle_in_broadcast_2")
    BackupAgent.put(socket.assigns[:game], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_out("update", payload, socket) do
    IO.puts("Handling Out! Update!")
    push(socket, "update", payload)
    {:noreply, socket}
  end

  def handle_in("new", payload, socket) do
    game_name = socket.assigns[:game]
    game = BackupAgent.get(game_name)
    game = Game.new(game, game.player1Name, game.player2Name)
    BackupAgent.put(game_name, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
