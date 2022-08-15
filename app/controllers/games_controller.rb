require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid]
    final_score = 0
    final_m = "Congratulations! #{@guess} is a valid English word!"
    if validate
      dictionary = load_dictionary(@guess)
      dictionary["found"] ? final_score = dictionary["length"] : final_m = "Sorry but #{@guess} does not seem to be a valid English word..."
    else
      final_m = "Sorry but #{@guess} can't be built out of #{@grid}"
    end
    @score = (final_score * 10).round
    @message = final_m
  end

  def load_dictionary(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary_serialized = URI.open(url).read
    return JSON.parse(dictionary_serialized)
  end

  def validate
    try = @guess.upcase.chars
    try.all? do |letter|
      try.count(letter) <= @grid.count(letter)
    end
  end
end
