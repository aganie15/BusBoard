require 'httparty'
require 'json'
require './BusApi'

# london bus stop code = 490008660N
def bus_board
  puts 'Please enter a bus stop code'
  stop_code = gets.chomp
  api = BusApi.new
  api.get_arrival_times(stop_code)
end

bus_board
