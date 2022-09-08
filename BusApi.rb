class BusApi
  def get_arrival_times(stop_code)
    response = HTTParty.get("https://api.tfl.gov.uk/StopPoint/#{stop_code}/Arrivals")
    bus_info = JSON.parse(response.to_s)

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
    bus_array = bus_array[0..5]
    puts(bus_array)
  end
end