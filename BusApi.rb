require 'httparty'

def get_response(request)
  response = HTTParty.get(request)
  return JSON.parse(response.to_s)
end
class BusApi
  def get_nearest_stop_codes(postcode)
    postcode_info = get_response("https://api.postcodes.io/postcodes/#{postcode}")
    longitude = postcode_info['result']['longitude']
    latitude = postcode_info['result']['latitude']
    nearest_stop_array = get_response("https://api.tfl.gov.uk/StopPoint/?lat=#{latitude}&lon=#{longitude}&stopTypes=NaptanPublicBusCoachTram")['stopPoints']
    # extract useful info??
    nearest_stop_array.sort_by! {|hsh| hsh['distance']}
    #if nearest_stop_array.length > 2
    #  nearest_stop_array = nearest_stop_array[0..2]
    #end
    stop_code_array = []
    #puts nearest_stop_array
    for entry in nearest_stop_array
      stop_code_array.push(entry['naptanId'])
    end
    return stop_code_array
  end

  def get_arrival_times(stop_code)
    # this call is not working!
    bus_info = get_response("https://api.tfl.gov.uk/StopPoint/#{stop_code}/Arrivals")

    # parse the information into a hash, which uses the vehicle_id as a key
    bus_array = []
    for entry in bus_info
      current = {}
      current['id'] = entry['vehicleId']
      current['destination'] = entry['destinationName']
      current['line_number'] = entry['lineId']
      current['mins_to_arrival'] = (entry['timeToStation'] / 60).round
      bus_array.push(current)
    end
    bus_array.sort_by! {|hsh| hsh['mins_to_arrival']}

    # select only the first 5 elements
    if bus_array.length > 5
      bus_array = bus_array[0..5]
    end

    # Print some bus stop info here
    if bus_info != []
      puts "Bus stop name: #{bus_info[1]['stationName']}"
      puts 'Upcoming arrivals:'
      for bus in bus_array
        puts "Line number: #{bus['line_number']}, Destination: #{bus['destination']}, Minutes until arrival: #{bus['mins_to_arrival']}"
      end
      puts ''
      return true # could use these to count the number of output arrivals in BusBoard
    else
      return false
    end
  end
end
