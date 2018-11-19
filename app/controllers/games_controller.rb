require "json"
require "open-uri"

class GamesController < ApplicationController
  def initialize
  end

  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def included_letters?(string_1, string_2)
    string_1.downcase.split("").all? {|letter| string_2.downcase.split("").count(letter) >= string_1.count(letter)}
  end

  def score
    @input = params[:input]
    @letters = params[:letters]
    @dictionary_response = JSON.parse(open('https://wagon-dictionary.herokuapp.com/'+@input).read)
    if !@dictionary_response["found"]
      @message = "Your entry (#{@input}) is not a word!"
    elsif  !included_letters?(@input, @letters)
      @message = "Your word (#{@input}) uses letters not found in game letters (#{@letters})"
    else
      @message = "Congrats! Your score is #{@input.length}"
    end
  end
end
