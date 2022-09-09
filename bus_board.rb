require 'httparty'
require 'json'
require './BusApi'

# london bus stop code = 490008660N / postcode = NW51TL
def bus_board
  postcode = ''
  valid = false
  # allow the postcode to only consist of letters and numbers
  until valid
    puts 'Please enter a valid postcode without any spaces'
    postcode = gets.chomp

    if postcode.match(/^[a-zA-Z0-9]+$/)
      response = HTTParty.get("https://api.postcodes.io/postcodes/#{postcode}/validate")
      valid = JSON.parse(response.to_s)['result']
    end
  end

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
  if stop_codes.empty?
    puts "Sorry there are no buses near that postcode"
  end
end

bus_board
