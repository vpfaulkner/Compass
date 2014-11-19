class Location < ActiveRecord::Base

  def get_coordinates(address)
    Geocoder.coordinates(address)
  end

end
