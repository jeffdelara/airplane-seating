require 'json'
class SeatingsController < ApplicationController
  def index 

  end

  def arrange 
    begin
      # Get array from user
      arr = JSON.parse(params[:array2d])
      @airplane = AirplaneSeating.new
      # initialize default values
      @airplane.init 
      # Set seats
      @airplane.set_seats(arr)
      # Set number of passengers
      @airplane.passengers = params[:passengers].to_i
      # Place the passengers to appropriate seats
      @seating_arrangement = @airplane.place_passengers_to_seats
      # If passenger is greater than the number of seats available, let put a message for the unseated passengers
      @not_seated = @airplane.passengers - @airplane.get_total_seats
    rescue => exception
      flash[:error] = "Must be an array of 2D arrays."
      redirect_to root_path
    end
    
  end 
end
