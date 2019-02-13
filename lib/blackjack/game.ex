defmodule Blackjack.Game do
  
  def new(name) do
    %{
      letters: Enum.shuffle(["AH", "AS", "AC", "AD", "2H", "2C", "2S", "2D", "3H", "3C", "3S", "3D", "4H", "4C", "4S", "4D",
                             "5H", "5C", "5S", "5D", "6H", "6C", "6S", "6D", "7H", "7C", "7S", "7D", "8H", "8C", "8S", "8D",
                             "9H", "9C", "9S", "9D", "0H", "0S", "0C", "0D", "JH", "JC", "JS", "JD", "QH", "QC", "QS", "QD",
                             "KH", "KC", "KS", "KD"]),
      discard: [],
      player1: [],
      player2: [],
      name: name,
      win: false,
      clickable: true,
    }
  end

  def hit(state) do
    IO.puts("Hit!")
  end

  def stand(state) do
    IO.puts("Stand!")
  end
end
