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

  def handle_in("click", payload, socket) do
    game = Game.cardClicked(socket.assigns[:game], payload["index"])
    Blackjack.BackupAgent.put(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("update", payload, socket) do
    game = %{
      board: payload["board"],
      letters: payload["letters"],
      correct: payload["correct"],
      name: payload["name"],
      win: payload["win"],
      clickable: payload["clickable"],
      click: payload["click"],
      score: payload["score"],
      i: payload["i"],
      j: payload["j"]
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
