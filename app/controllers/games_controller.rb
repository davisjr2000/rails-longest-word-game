require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def index
    session[:score] = 0
    session[:attempts] = 0
  end
  def new
    letters = (0...7).map { rand(65..90).chr }
    2.times do
      letters << ["A", "E", "I", "O", "U"].sample
    end
    @letters = letters.shuffle
    @start_time = Time.now
  end

  def score
    session[:attempts] += 1
    @attempt = params['attempt']
    @letters = params[:letters]
    @start_time = params[:start_time]
    if @attempt.nil? || @attempt == ""
      @result = "Type something you stupid piece of shit"
      @score = -1
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
        @score = -3
        @message = "Learn to write"
      elsif data['found'] == true && gridok == false
        @result = "#{@attempt} is not in the grid"
        @score = - 5
        @message = "Learn to read"
      else
        @result = "Well Done! #{@attempt} was a great choice"
        @score = (5 * @attempt.length - (Time.now - @start_time.to_datetime)).round(2)
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
    session[:score] += @score
    redirect_to final_path if session[:score] >= 50
    redirect_to badfinal_path if session[:score] <= -20
  end
end
