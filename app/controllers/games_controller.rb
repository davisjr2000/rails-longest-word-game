require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...9).map { rand(65..90).chr }
    @start_time = Time.now
  end

  def score
    @attempt = params['attempt']
    @letters = params[:letters]
    @start_time = params[:start_time]
    if @attempt.nil? || @attempt == ""
      @result = "Type something you stupid piece of shit"
      @score ="0, you didn't even try lol"
    else
      @attempt = @attempt.capitalize
      url = 'https://wagon-dictionary.herokuapp.com/' + @attempt
      user_serialized = open(url).read
      data = JSON.parse(user_serialized)
      gridok = true
      attempt_letters = @attempt.upcase.split('')
      attempt_letters.each do |att_letters|
        if @letters.include?(att_letters)
          @letters[@letters.index(att_letters)] = "NIL"
        else
          gridok = false
        end
      end
      if data['found'] == false
        @result = "#{@attempt} is not an English Word"
        @score = 0
        @message = "Learn to write"
      elsif data['found'] == true && gridok == false
        @result = "#{@attempt} is not in the grid"
        @score = 0
        @message = "Learn to read"
      else
        @result = "Well Done! #{@attempt} was a great choice"
        @score = 5 * @attempt.length - (Time.now - @start_time.to_datetime)
        if @score < 0
          if @score > -1
            @message = "Slow huh"
          else
            @message = "LOL U LOST LIKE #{@score.to_i.abs} POINTS"
          end
        elsif @score > 0 && @score < 14
          @message = "Good job :)"
        else
          @message = "WOW HE HAVE A SHERLOCK HOLMES HERE"
        end
      end
    end
  end
end
