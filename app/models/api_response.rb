class APIResponse

  class NoLocationError < StandardError
  end

  def self.legislators_database
    @legislator_db ||= YAML.load_file("#{Rails.root}/app/assets/legislators-current.yaml")
  end

  attr_reader :api_response

  def initialize(identifier, required_fields)
    @api_response = Hash.new
    begin
      identified_legislators = find_legislators(identifier)
      legislators_collection = create_legislators_collection(identified_legislators, required_fields)
      wrap_legislators_collection(legislators_collection)
    rescue NoLocationError
      @api_response["Error"] = "not a valid address"
    end
  end

  def find_legislators(identifier)
    json_response = Array.new
    if identifier[:all]
      json_response.push({issue: identifier[:issue]})
    elsif identifier[:address]
      local_legislators = get_local_legislators(identifier[:address])
      local_legislators["response"]["legislators"].each do |l|
        json_response.concat(get_legislator_in_database(l["legislator"]["lastname"],
                                               l["legislator"]["state"],
                                               l["legislator"]["title"].downcase))
      end
    else
      json_response.concat(get_legislator_in_database(identifier[:lastname], identifier[:state], identifier[:title]))
    end
    json_response
  end

  def get_local_legislators(address)
    location = Geocoder.coordinates(address)
    raise NoLocationError unless location
    json_response = HTTParty.get('http://services.sunlightlabs.com/api/legislators.allForLatLong.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],latitude: location[0], longitude: location[1]})
  end

  def get_legislator_in_database(last, state, title)
    APIResponse.legislators_database.select do |y|
      y["name"]["last"] == last &&
      y["terms"].last["state"] == state &&
      y["terms"].last["type"] == title
    end
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
    @api_response["legislators"] = legislators_collection
  end

end
