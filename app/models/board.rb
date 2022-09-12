require 'httparty'
class Board < ApplicationRecord
  def get_response(request)
    response = HTTParty.get(request)
    return JSON.parse(response.to_s)
  end
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

  # identifies the bus arrivals at a particular stop and returns a list of Bus Objects which can be used in our view
  def get_arrival_times(stop_code)
    bus_info = get_response("https://api.tfl.gov.uk/StopPoint/#{stop_code}/Arrivals")
    bus_object_list = []
    for entry in bus_info
      mins_to_arrival = (entry['timeToStation'] / 60).round
      # required to bypass a mysterious bug
      list_of_args = {
        :station_stop_code => stop_code,
        :bus_info_entry => entry}
      # these buses are apparently not getting initialised
      current_bus = Bus.new
      current_bus.station_stop_code = list_of_args[:station_stop_code]
      current_bus.bus_info_entry = list_of_args[:bus_info_entry]
      bus_object_list.push(current_bus)
    end
    bus_object_list.sort_by! {|bus_object| bus_object.get_mins_to_arrival}
    return bus_object_list
  end
  def get_station_name(stop_code)
    bus_info = get_response("https://api.tfl.gov.uk/StopPoint/#{stop_code}/Arrivals")
    bus_info[0]['stationName']
  end
end
