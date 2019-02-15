defmodule Blackjack.Game do
  def new(name) do
    defaultDeck = Enum.shuffle(["AH", "AS", "AC", "AD", "2H", "2C", "2S", "2D", "3H", "3C", "3S", "3D", "4H", "4C", "4S", "4D",
                        "5H", "5C", "5S", "5D", "6H", "6C", "6S", "6D", "7H", "7C", "7S", "7D", "8H", "8C", "8S", "8D",
                        "9H", "9C", "9S", "9D", "0H", "0S", "0C", "0D", "JH", "JC", "JS", "JD", "QH", "QC", "QS", "QD",
                        "KH", "KC", "KS", "KD"])
    initiate(name, defaultDeck)
  end

  def initiate(name, deck) do
    p1Card1 = elem(List.pop_at(deck, 0), 0)
    p1Card2 = elem(List.pop_at(deck, 2), 0)
    p2Card1 = elem(List.pop_at(deck, 1), 0)
    p2Card2 = elem(List.pop_at(deck, 3), 0)
    tempPlayer1 = [p1Card1] ++ [p1Card2]
    tempPlayer1Sum = calcHand(tempPlayer1)
    tempPlayer2 = [p2Card1] ++ [p2Card2]
    tempPlayer2Sum = calcHand(tempPlayer2)
    tempDeck = Enum.drop(deck, 4)
      %{
        deck: tempDeck,
        discard: [p1Card1] ++ [p2Card2] ++ [p1Card2] ++ [p2Card2],
        player1: tempPlayer1,
        player1Name: "Player1",
        player1Sum: tempPlayer1Sum,
        player1Score: 0,
        player2: tempPlayer2,
        player2Name: "Player2",
        player2Sum: tempPlayer2Sum,
        player2Score: 0,
        playerTurn: 1,
        round: 1,
        win: false,
        name: name,
      }
  end

  def newRound(state, p1Score, p2Score) do
    deck = Enum.shuffle(state.deck ++ state.discard)
    p1Card1 = elem(List.pop_at(deck, 0), 0)
    p1Card2 = elem(List.pop_at(deck, 2), 0)
    p2Card1 = elem(List.pop_at(deck, 1), 0)
    p2Card2 = elem(List.pop_at(deck, 3), 0)
    tempPlayer1 = [p1Card1] ++ [p1Card2]
    tempPlayer1Sum = calcHand(tempPlayer1)
    tempPlayer2 = [p2Card1] ++ [p2Card2]
    tempPlayer2Sum = calcHand(tempPlayer2)
    tempDeck = Enum.drop(deck, 4)
      %{
        deck: tempDeck,
        discard: [p1Card1] ++ [p2Card2] ++ [p1Card2] ++ [p2Card2],
        player1: tempPlayer1,
        player1Name: "Player1",
        player1Sum: tempPlayer1Sum,
        player1Score: p1Score,
        player2: tempPlayer2,
        player2Name: "Player2",
        player2Sum: tempPlayer2Sum,
        player2Score: p2Score,
        playerTurn: 1,
        round: state.round + 1,
        win: false,
        name: state.name,
      }
  end

  def calcHand(pList) do
    if length(pList) != 0 do
      val = String.first(List.first(pList))
      cond do
        val == "A" -> 11 + calcHand(tl(pList))
        val == "0" || val == "J" || val == "Q" || val == "K" -> 10 + calcHand(tl(pList))
        true -> elem(Integer.parse(val), 0) + calcHand(tl(pList))
      end
    else
      0
    end
  end

  def hit(state) do
    newCard = elem(List.pop_at(state.deck, 0), 0)
    tempDeck = elem(List.pop_at(state.deck, 0), 1)
    tempDiscard = state.discard ++ [newCard]
    if state.playerTurn == 1 do
      IO.puts(state.player1)
      if state.player1Sum > 21 do
        stand(state)
      else
      tempPlayer1 = state.player1 ++ [newCard]
      totalPlayer1 = calcHand(tempPlayer1)
      IO.puts("Hit!")
      %{
        deck: tempDeck,
        discard: tempDiscard,
        player1: tempPlayer1,
        player1Name: state.player1Name,
        player1Sum: totalPlayer1,
        player1Score: state.player1Score,
        player2: state.player2,
        player2Name: state.player2Name,
        player2Sum: state.player2Sum,
        player2Score: state.player2Score,
        playerTurn: state.playerTurn,
        round: state.round,
        win: state.win,
        name: state.name,
      }
      end
    else
      IO.puts(state.player2)
      if state.player2Sum > 21 do
        stand(state)
      else
      tempPlayer2 = state.player2 ++ [newCard]
      totalPlayer2 = calcHand(tempPlayer2)
      IO.puts("Hit!")
      %{
        deck: tempDeck,
        discard: tempDiscard,
        player1: state.player1,
        player1Name: state.player1Name,
        player1Sum: state.player1Sum,
        player1Score: state.player1Score,
        player2: tempPlayer2,
        player2Name: state.player2Name,
        player2Sum: totalPlayer2,
        player2Score: state.player2Score,
        playerTurn: state.playerTurn,
        round: state.round,
        win: state.win,
        name: state.name,
      }
      end
    end
  end

  def nextTurn(turn) do
    cond do
      turn == 1 -> 2
      turn == 2 -> 1
    end
  end

  def calcScores(state) do
    if state.playerTurn == 2  do
      cond do
        state.player1Sum > 21 && state.player2Sum > 21 -> {state.player1Score, state.player2Score, true}
        state.player1Sum > 21 && state.player2Sum < 21 -> {state.player1Score, state.player2Score + 1, true}
        state.player2Sum > 21 && state.player1Sum < 21 -> {state.player1Score + 1, state.player2Score, true}
        state.player1Sum > state.player2Sum -> {state.player1Score + 1, state.player2Score, true}
        state.player2Sum > state.player1Sum -> {state.player1Score, state.player2Score + 1, true}
        state.player2Sum == state.player1Sum -> {state.player1Score, state.player2Score, true}
        true -> {state.player1Score, state.player2Score, false}
      end
    else
      {state.player1Score, state.player2Score, false}
    end
  end

  def stand(state) do
    IO.puts("Stand!")
    IO.inspect(state)
    tempPlayerTurn = nextTurn(state.playerTurn)
    scores = calcScores(state)
    p1Score = elem(scores, 0)
    p2Score = elem(scores, 1)
    if elem(scores, 2) do
      newRound(state, p1Score, p2Score)
    else
    %{
      deck: state.deck,
      discard: state.discard,
      player1: state.player1,
      player1Name: state.player1Name,
      player1Sum: state.player1Sum,
      player1Score: p1Score,
      player2: state.player2,
      player2Name: state.player2Name,
      player2Sum: state.player2Sum,
      player2Score: p2Score,
      playerTurn: tempPlayerTurn,
      round: state.round,
      win: state.win,
      name: state.name,
    }
    end
  end
end
