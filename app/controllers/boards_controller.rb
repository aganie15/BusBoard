class BoardsController < ApplicationController
  def display
    postcode = params[:postcode]
    # call the model here using our postcode
    bus_stop = Board.new
    nearest_stop_codes = bus_stop.get_nearest_stop_codes(postcode)
    puts nearest_stop_codes
  end
end
