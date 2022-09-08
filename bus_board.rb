require 'httparty'
require 'json'
require './BusApi'

# london bus stop code = 490008660N / postcode = NW51TL
def bus_board
  puts 'Please enter a postcode'
  postcode = gets.chomp
  api = BusApi.new
  stop_codes = api.get_nearest_stop_codes(postcode)
  counter = 0
  for stop_code in stop_codes
    if counter < 2
      completed_sucessfully = api.get_arrival_times(stop_code)
      if completed_sucessfully
        counter = counter + 1
      end
    else
      break
    end
  end
end

bus_board
