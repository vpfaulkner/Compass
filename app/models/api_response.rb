class APIResponse

  attr_reader :api_response

  def initialize(identifier, required_fields)
    identified_legislators = find_legislators_by_identifier(identifier)
    legislators_collection = create_legislators_collection(identified_legislators, required_fields)
    wrap_legislators_collection(legislators_collection)
  end

  def find_legislators_by_identifier(identifier)
    if identifier[:address]
      location = Geocoder.coordinates(identifier[:address])
      json_response = HTTParty.get('http://services.sunlightlabs.com/api/legislators.allForLatLong.json',
      query: {apikey: ENV['SUNLIGHT_KEY'],latitude: location[0], longitude: location[1]})
    elsif identifier[:lastname] && identifier[:state] && identifier[:title]
      json_response = HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
      query: {apikey: ENV['SUNLIGHT_KEY'],lastname: identifier[:lastname], state: identifier[:state], title: identifier[:title]})
    end
    json_response["response"]["legislators"]
  end

  def create_legislators_collection(identified_legislators, required_fields)
    legislators_collection = Array.new
    identified_legislators.each do |legislator|
      legislator = Legislator.new(legislator, required_fields).new_legislator_object
      legislators_collection.push(legislator)
    end
    legislators_collection
  end

  def wrap_legislators_collection(legislators_collection)
    @api_response = Hash.new
    @api_response["legislators"] = legislators_collection
  end

end
