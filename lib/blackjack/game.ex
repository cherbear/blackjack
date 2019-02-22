defmodule Blackjack.Game do
  def new(name) do
    defaultDeck = Enum.shuffle(["AH", "AS", "AC", "AD", "2H", "2C", "2S", "2D", "3H", "3C", "3S", "3D", "4H", "4C", "4S", "4D",
                        "5H", "5C", "5S", "5D", "6H", "6C", "6S", "6D", "7H", "7C", "7S", "7D", "8H", "8C", "8S", "8D",
                        "9H", "9C", "9S", "9D", "0H", "0S", "0C", "0D", "JH", "JC", "JS", "JD", "QH", "QC", "QS", "QD",
                        "KH", "KC", "KS", "KD"])
    initiate(name, defaultDeck)
  end

  def new(name, p1, p2) do
    defaultDeck = Enum.shuffle(["AH", "AS", "AC", "AD", "2H", "2C", "2S", "2D", "3H", "3C", "3S", "3D", "4H", "4C", "4S", "4D",
                        "5H", "5C", "5S", "5D", "6H", "6C", "6S", "6D", "7H", "7C", "7S", "7D", "8H", "8C", "8S", "8D",
                        "9H", "9C", "9S", "9D", "0H", "0S", "0C", "0D", "JH", "JC", "JS", "JD", "QH", "QC", "QS", "QD",
                        "KH", "KC", "KS", "KD"])
    initiate(name, defaultDeck, p1, p2)
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
        prevPlayer1Sum: 0,
        player1Score: 0,
        player2: tempPlayer2,
        player2Name: "Player2",
        player2Sum: tempPlayer2Sum,
        prevPlayer2Sum: 0,
        player2Score: 0,
        playerTurn: 1,
        round: 1,
        win: false,
        name: name,
        prevPlayer1: [],
        prevPlayer2: [],
        prevPlayer1Sum: 0,
        prevPlayer2Sum: 0, 
      }
  end

  def initiate(name, deck, p1, p2) do
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
        player1Name: p1,
        player1Sum: tempPlayer1Sum,
        prevPlayer1Sum: 0,
        player1Score: 0,
        player2: tempPlayer2,
        player2Name: p2,
        player2Sum: tempPlayer2Sum,
        prevPlayer2Sum: 0,
        player2Score: 0,
        playerTurn: 1,
        round: 1,
        win: false,
        name: name,
        prevPlayer1: [],
        prevPlayer2: [],
        prevPlayer1Sum: 0,
        prevPlayer2Sum: 0, 
      }
  end
  
  def userJoin(state, user) do
    cond do
      state.player1Name == "Player1" ->
          %{
            deck: state.deck,
            discard: state.discard,
            player1: state.player1,
            player1Name: user,
            player1Sum: state.player1Sum,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: state.player2,
            player2Name: state.player2Name,
            player2Sum: state.player2Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
      state.player2Name == "Player2" && user != state.player1Name ->
          %{
            deck: state.deck,
            discard: state.discard,
            player1: state.player1,
            player1Name: state.player1Name,
            player1Sum: state.player1Sum,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: state.player2,
            player2Name: user,
            player2Sum: state.player2Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
      true -> state #For spectators
    end
  end

  def hideCards(cards) do
    cond do
      length(cards) == 0 -> []
      true -> ["--"] ++ hideCards(tl(cards))
    end
  end

  def clientView(state, user) do
    cond do
      user == state.player1Name ->
          player2Hidden = hideCards(state.player2)
          %{
            deck: state.deck,
            discard: state.discard,
            player1: state.player1,
            player1Name: state.player1Name,
            player1Sum: state.player1Sum,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: player2Hidden,
            player2Name: state.player2Name,
            player2Sum: 0,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
      user == state.player2Name ->
          player1Hidden = hideCards(state.player1)
          %{
            deck: state.deck,
            discard: state.discard,
            player1: player1Hidden,
            player1Name: state.player1Name,
            player1Sum: 0,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: state.player2,
            player2Name: state.player2Name,
            player2Sum: state.player2Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
      true -> state #For spectators
    end
  end
  
  def newRound(state, p1Score, p2Score, prevPlayer1Sum, prevPlayer2Sum, p1Name, p2Name) do
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
        player1Name: p1Name,
        prevPlayer1Sum: prevPlayer1Sum,
        player1Sum: tempPlayer1Sum,
        player1Score: p1Score,
        player2: tempPlayer2,
        player2Name: p2Name,
        prevPlayer2Sum: prevPlayer2Sum,
        player2Sum: tempPlayer2Sum,
        player2Score: p2Score,
        playerTurn: 1,
        round: state.round + 1,
        win: false,
        name: state.name,
        prevPlayer1: state.player1,
        prevPlayer2: state.player2,
        prevPlayer1Sum: state.player1Sum,
        prevPlayer2Sum: state.player2Sum,
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

  def findAce(hand, index) do
    cond do
      length(hand) == 0 -> {-1, "-1"}
      String.contains?(List.first(hand), "A") -> {index, String.slice(List.first(hand), 1, 1)}
      true -> findAce(tl(hand), index + 1)
    end
  end

  def bust(state, op) do
    cond do
      state.playerTurn == 1 ->
        if elem(findAce(state.player1, 0), 0) != -1 do
          aceIndex = findAce(state.player1, 0)
          newPlayer1 = List.replace_at(state.player1, elem(aceIndex, 0), Enum.join(["1", elem(aceIndex, 1)], ""))
          totalPlayer1 = calcHand(newPlayer1)
          newState = %{
            deck: state.deck,
            discard: state.discard,
            player1: newPlayer1,
            player1Name: state.player1Name,
            player1Sum: totalPlayer1,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: state.player2,
            player2Name: state.player2Name,
            player2Sum: state.player2Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
          cond do
            op == "hit" -> hit(newState)
            op == "stand" -> stand(newState)
          end
        else
          stand(state)
        end
      state.playerTurn == 2 ->
        if elem(findAce(state.player2, 0), 0) != -1 do
          aceIndex = findAce(state.player2, 0)
          newPlayer2 = List.replace_at(state.player2, elem(aceIndex, 0), Enum.join(["1", elem(aceIndex, 1)], ""))
          totalPlayer2 = calcHand(newPlayer2)
          newState = %{
            deck: state.deck,
            discard: state.discard,
            player1: state.player1,
            player1Name: state.player1Name,
            player1Sum: state.player1Sum,
            prevPlayer1Sum: state.prevPlayer1Sum,
            player1Score: state.player1Score,
            player2: newPlayer2,
            player2Name: state.player2Name,
            player2Sum: totalPlayer2,
            prevPlayer2Sum: state.prevPlayer2Sum,
            player2Score: state.player2Score,
            playerTurn: state.playerTurn,
            round: state.round,
            win: state.win,
            name: state.name,
            prevPlayer1: state.prevPlayer1,
            prevPlayer2: state.prevPlayer2,
            prevPlayer1Sum: state.prevPlayer1Sum,
            prevPlayer2Sum: state.prevPlayer2Sum,
          }
          cond do
            op == "hit" -> hit(newState)
            op == "stand" -> stand(newState)
          end
        else
          stand(state)
        end
    end
  end

  def hit(state) do
    cond do
      calcHand(state.player1) > 21 && state.playerTurn == 1 -> bust(state, "hit")
      calcHand(state.player2) > 21 && state.playerTurn == 2 -> bust(state, "hit")
      true ->
    if state.playerTurn == 1 do
        newCard = elem(List.pop_at(state.deck, 0), 0)
        tempDeck = elem(List.pop_at(state.deck, 0), 1)
        tempDiscard = state.discard ++ [newCard]
        tempPlayer1 = state.player1 ++ [newCard]
        totalPlayer1 = calcHand(tempPlayer1)
        IO.puts("Hit!")
        %{
          deck: tempDeck,
          discard: tempDiscard,
          player1: tempPlayer1,
          player1Name: state.player1Name,
          player1Sum: totalPlayer1,
          prevPlayer1Sum: state.prevPlayer1Sum,
          player1Score: state.player1Score,
          player2: state.player2,
          player2Name: state.player2Name,
          player2Sum: state.player2Sum,
          prevPlayer2Sum: state.prevPlayer2Sum,
          player2Score: state.player2Score,
          playerTurn: state.playerTurn,
          round: state.round,
          win: state.win,
          name: state.name,
          prevPlayer1: state.prevPlayer1,
          prevPlayer2: state.prevPlayer2,
          prevPlayer1Sum: state.prevPlayer1Sum,
          prevPlayer2Sum: state.prevPlayer2Sum,
        }
    else
        newCard = elem(List.pop_at(state.deck, 0), 0)
        tempDeck = elem(List.pop_at(state.deck, 0), 1)
        tempDiscard = state.discard ++ [newCard]
        tempPlayer2 = state.player2 ++ [newCard]
        totalPlayer2 = calcHand(tempPlayer2)
        IO.puts("Hit!")
        %{
          deck: tempDeck,
          discard: tempDiscard,
          player1: state.player1,
          player1Name: state.player1Name,
          player1Sum: state.player1Sum,
          prevPlayer1Sum: state.prevPlayer1Sum,
          player1Score: state.player1Score,
          player2: tempPlayer2,
          player2Name: state.player2Name,
          player2Sum: totalPlayer2,
          prevPlayer2Sum: state.prevPlayer2Sum,
          player2Score: state.player2Score,
          playerTurn: state.playerTurn,
          round: state.round,
          win: state.win,
          name: state.name,
          prevPlayer1: state.prevPlayer1,
          prevPlayer2: state.prevPlayer2,
          prevPlayer1Sum: state.prevPlayer1Sum,
          prevPlayer2Sum: state.prevPlayer2Sum,
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
        Enum.member?(state.player1, "AS") && (Enum.member?(state.player1, "JS") || Enum.member?(state.player1, "JC")) && length(state.player1) == 2 -> {state.player1Score + 3, state.player2Score, true}
        Enum.member?(state.player2, "AS") && (Enum.member?(state.player2, "JS") || Enum.member?(state.player2, "JC")) && length(state.player2) == 2 -> {state.player1Score, state.player2Score + 3, true}
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
    cond do
      calcHand(state.player1) > 21 && state.playerTurn == 1 && elem(findAce(state.player1, 0), 0) != -1 -> bust(state, "stand")
      calcHand(state.player2) > 21 && state.playerTurn == 2 && elem(findAce(state.player2, 0), 0) != -1 -> bust(state, "stand")
      true ->
    IO.puts("Stand!")
    tempPlayerTurn = nextTurn(state.playerTurn)
    scores = calcScores(state)
    p1Score = elem(scores, 0)
    p2Score = elem(scores, 1)
    if elem(scores, 2) do
      prevPlayer1Sum = calcHand(state.player1)
      prevPlayer2Sum = calcHand(state.player2)
      if p1Score >= 5 || p2Score >= 5 do
        %{
          deck: state.deck,
          discard: state.discard,
          player1: state.player1,
          player1Name: state.player1Name,
          player1Sum: state.player1Sum,
          prevPlayer1Sum: state.prevPlayer1Sum,
          player1Score: p1Score,
          player2: state.player2,
          player2Name: state.player2Name,
          player2Sum: state.player2Sum,
          prevPlayer2Sum: state.prevPlayer2Sum,
          player2Score: p2Score,
          playerTurn: tempPlayerTurn,
          round: state.round,
          win: true,
          name: state.name,
          prevPlayer1: state.prevPlayer1,
          prevPlayer2: state.prevPlayer2,
          prevPlayer1Sum: state.prevPlayer1Sum,
          prevPlayer2Sum: state.prevPlayer2Sum,
        } 
      else
        newRound(state, p1Score, p2Score, prevPlayer1Sum, prevPlayer2Sum, state.player1Name, state.player2Name)
      end
    else
    %{
      deck: state.deck,
      discard: state.discard,
      player1: state.player1,
      player1Name: state.player1Name,
      player1Sum: state.player1Sum,
      prevPlayer1Sum: state.prevPlayer1Sum,
      player1Score: p1Score,
      player2: state.player2,
      player2Name: state.player2Name,
      player2Sum: state.player2Sum,
      prevPlayer2Sum: state.prevPlayer2Sum,
      player2Score: p2Score,
      playerTurn: tempPlayerTurn,
      round: state.round,
      win: state.win,
      name: state.name,
      prevPlayer1: state.prevPlayer1,
      prevPlayer2: state.prevPlayer2,
      prevPlayer1Sum: state.prevPlayer1Sum,
      prevPlayer2Sum: state.prevPlayer2Sum,
    }
    end
    end
  end
end
