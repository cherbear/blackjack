defmodule Blackjack.Game do
  
  def new(name) do
    %{
      letters: Enum.shuffle(["AH", "AS", "AC", "AD", "2H", "2C", "2S", "2D", "3H", "3C", "3S", "3D", "4H", "4C", "4S", "4D",
                             "5H", "5C", "5S", "5D", "6H", "6C", "6S", "6D", "7H", "7C", "7S", "7D", "8H", "8C", "8S", "8D",
                             "9H", "9C", "9S", "9D", "0H", "0S", "0C", "0D", "JH", "JC", "JS", "JD", "QH", "QC", "QS", "QD",
                             "KH", "KC", "KS", "KD"]),
      board: ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
      correct: [],
      name: name,
      win: false,
      clickable: true,
      clicks: 0,
      score: 0,
      i: -1,
      j: -1
    }
  end

  def cardClicked(state, index) do
    if(state.clickable) do
      tempBoard = state.board
      tempCorrect = state.correct
      tempClickable = state.clickable
      tempClicks = state.clicks
      tempScore = state.score
      indices = []
      indices = indices ++ [state.i]
      indices = indices ++ [index]
      IO.puts("-------DEBUG--------")
      IO.puts(tempBoard)
      IO.puts(state.i)
      IO.puts(index)
      #IO.puts(indices)
      if true do
        tempClicks = tempClicks + 1
        tempScore = tempScore - 1
        if rem(tempClicks, 2) == 1 do
          IO.puts("FLAG 1")
          tempBoard = List.replace_at(tempBoard, index, Enum.fetch!(state.letters, index))
          IO.puts(tempBoard)
          %{
            letters: state.letters,
            board: tempBoard,
            correct: tempCorrect,
            name: state.name,
            win: state.win,
            clickable: tempClickable,
            clicks: tempClicks,
            score: tempScore,
            i: Enum.fetch!(indices, 1),
            j: Enum.fetch!(indices, 0)
          }
        else
          IO.puts("FLAG 2")
          tempBoard = List.replace_at(tempBoard, index, Enum.fetch!(state.letters, index))
          if (Enum.fetch!(state.letters, Enum.fetch!(indices, 0)) ===
             Enum.fetch!(state.letters, Enum.fetch!(indices, 1))) do
            tempCorrect = tempCorrect ++ Enum.fetch!(indices, 0)
            tempCorrect = tempCorrect ++ Enum.fetch!(indices, 1)
            tempScore = tempScore + 15
          else
            tempClickable = false
          end
        end
        IO.puts("FLAG 3")
        IO.puts(tempBoard)
        %{
          letters: state.letters,
          board: tempBoard,
          correct: tempCorrect,
          name: state.name,
          win: state.win,
          clickable: tempClickable,
          clicks: tempClicks,
          score: tempScore,
          i: Enum.fetch!(indices, 1),
          j: Enum.fetch!(indices, 0)
        }
      else
        %{
          letters: state.letters,
          board: state.board,
          correct: state.correct,
          name: state.name,
          win: state.win,
          clickable: state.clickable,
          clicks: state.clicks,
          score: state.score,
          i: state.i,
          j: state.j
        }
      end
    else
        %{
          letters: state.letters,
          board: state.board,
          correct: state.correct,
          name: state.name,
          win: state.win,
          clickable: state.clickable,
          clicks: state.clicks,
          score: state.score,
          i: state.i,
          j: state.j
        }
    end
  end
end
