class BoardsController < ApplicationController
  def format_post_code(postcode)
    postcode.upcase.strip.sub(/([A-Z0-9]+)([A-Z0-9]{3})/, '\1 \2')
  end

  def validate_postcode(postcode)
    if postcode.match(/^[a-zA-Z0-9]+$/)
      response = HTTParty.get("https://api.postcodes.io/postcodes/#{postcode}/validate")
      JSON.parse(response.to_s)['result']
    else
      false
    end
  end
  def display
    # must remove any spaces from our postcode input
    @postcode = params[:postcode].delete(' ')
    # this hash will contain stop codes as keys and all the buses expected to arrive at that stop code as values
    @arrivals_hash = {}
    @pretty_postcode = format_post_code(@postcode)
    @arrival_num = 5
    @invalid_postcode = false
    # check to see if we have a valid postcode
    if validate_postcode(@postcode)
      board = Board.new
      nearest_stop_codes = board.get_nearest_stop_codes(@postcode)
      for stop_code in nearest_stop_codes
        current_bus_list = board.get_arrival_times(stop_code)
        # select only the *next* 5 buses
        current_bus_list = current_bus_list[0...@arrival_num]
        @arrivals_hash[stop_code] = current_bus_list
      end
      # this is a hash of stop codes to their names
      @stop_name_hash = {}
      for stop_code in nearest_stop_codes
        current_name = board.get_station_name(stop_code)
        @stop_name_hash[stop_code] = current_name
      end
    else
      @invalid_postcode = true
    end
  end
end
