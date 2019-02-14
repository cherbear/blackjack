defmodule BlackjackWeb.GamesChannel do
  use BlackjackWeb, :channel
  alias Blackjack.Game
  alias Blackjack.BackupAgent

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Blackjack.BackupAgent.get(name) || Game.new(name)
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("hit", payload, socket) do
    game = Game.hit(socket.assigns[:game])
    Blackjack.BackupAgent.put(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("stand", payload, socket) do
    game = Game.stand(socket.assigns[:game])
    Blackjack.BackupAgent.put(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end
  
  def handle_in("update", payload, socket) do
    game = %{
      player1: payload["player1"],
      player1Sum: payload["player1Sum"],
      player1Score: payload["player1Score"],
      player2: payload["player2"],
      player2Sum: payload["player2Sum"],
      player2Score: payload["player2Score"],
      playerTurn: payload["playerTurn"],
      round: payload["round"],
      name: payload["name"],
      win: payload["win"],
    }
    Blackjack.BackupAgent.put(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("new", payload, socket) do
    game = Game.new(payload["name"])
    Blackjack.BackupAgent.put(socket.assigns[:name], game)
    socket = socket
    |> assign(:game, game)
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
