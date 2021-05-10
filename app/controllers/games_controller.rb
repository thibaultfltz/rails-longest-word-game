require 'open-uri'
class GamesController < ApplicationController

  def new
    @letters = []
    for i in 1..10 do
      @letters << ('A'..'Z').to_a.sample(1)
    end
    @letters.flatten
  end

  def score
    letters = params[:letters].split
    @result = { score: 0, message: "", win: false}
    filepath = "https://wagon-dictionary.herokuapp.com/#{params[:input]}"
    attempt = params[:input].upcase
    serialized_word = URI.open(filepath).read
    word = JSON.parse(serialized_word)
    english_word = word["found"]
    word_in_grid = attempt.chars.all? { |letter| letters.count(letter) >= attempt.count(letter) }
    if english_word & word_in_grid
      @result[:score] = 10 + attempt.length
      @result[:message] = "Well done"
      @result[:win] = true
    elsif word_in_grid == false && english_word
      @result[:message] = "not in the grid"
    else
      @result[:message] = "not an english word"
    end
  end
end
