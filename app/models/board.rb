class Board < ApplicationRecord
  #self.table_name = 'Boards'
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
end
