class Location < ActiveRecord::Base

  def self.get_coordinates(address)
    Geocoder.coordinates(address)
  end

end
